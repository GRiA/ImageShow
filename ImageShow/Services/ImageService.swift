//
//  ImageService.swift
//  ImageShow
//
//  Created by Anton Grishin on 14.04.2026.
//

import UIKit
import CryptoKit

actor ImageService {
	public enum ImageSize {
		case preview
		case full
	}
	static let shared = ImageService()
	
	private nonisolated let previewCache: SmoothCache
	private nonisolated let imageCache: SmoothCache
	private let cacheUrl: URL
	private let previewCacheUrl: URL
	
	init?(){
		guard
			let cacheUrl = try? FileManager.default.imageCacheUrl,
			let previewUrl = try? FileManager.default.previewCacheUrl
		else {
			return nil
		}
		self.cacheUrl = cacheUrl
		self.previewCacheUrl = previewUrl
		
		previewCache = SmoothCache()
		imageCache = SmoothCache()
	}
	
	nonisolated func cachedImage(from url: URL, with size: ImageSize) -> UIImage? {
		let fileName = "\(url.persistentHash).img"
		let cache = size == .full ? imageCache : previewCache
		let image = cache.get(fileName)
		guard
			image != nil
		else {
			let folderUrl = size == .full ? cacheUrl : previewCacheUrl
			let fileUrl = folderUrl.appendingPathComponent(fileName)
			if FileManager.default.fileExists(atPath: fileUrl.path()),
			   let data = try? Data(contentsOf: fileUrl),
			   let image = UIImage(data: data) {
				cache.set(image, for: fileName)
				return image
			}
			return nil
		}
		return image
	}
	
	func fetchImage(from url: URL, with size: ImageSize) async throws -> UIImage? {
		if let image = cachedImage(from: url, with: size) {
			return image
		}
		return try await fetchImage(from: url, size: size)
	}
}

private extension ImageService {
	func fetchImage(from url: URL, size: ImageSize) async throws -> UIImage? {
		let (data, response) = try await URLSession.shared.data(from: url)
		let httpResponse = response as? HTTPURLResponse
		let code = httpResponse?.statusCode ?? 404
		guard
			(200 ..< 300).contains(code)
		else {
			throw URLError(URLError.Code(rawValue: code))
		}
		
		let fileName = "\(url.persistentHash).img"
		saveImage(data, for: fileName)
		createThumbnail(from: data, size: 150.0, fileName: fileName)
		return cachedImage(from: url, with: size)
	}
	
	func saveImage(_ data: Data, for fileName: String) {
		guard let image = UIImage(data: data) else { return }
		let fileUrl = cacheUrl.appendingPathComponent(fileName)
		imageCache.set(image, for: fileName)
		try? data.write(to: fileUrl)
	}
	
	func createThumbnail(from data: Data, size: CGFloat, fileName: String) {
		let options: [CFString: Any] = [
			kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
			kCGImageSourceCreateThumbnailWithTransform: true,
			kCGImageSourceShouldCacheImmediately: true,
			kCGImageSourceThumbnailMaxPixelSize: size
		]
		
		guard let source = CGImageSourceCreateWithData(data as CFData, nil),
			  let cgimage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
			return
		}
		let image = UIImage(cgImage: cgimage)
		previewCache.set(image, for: fileName)
		let fileUrl = previewCacheUrl.appendingPathComponent(fileName)
		if let thumbData = image.jpegData(compressionQuality: 0.6) {
			try? thumbData.write(to: fileUrl)
		}
	}
}

extension URL {
	nonisolated var persistentHash: String {
		let data = Data(self.absoluteString.utf8)
		let hash = Insecure.MD5.hash(data: data)
		return hash.map { String(format: "%02hhx", $0) }.joined()
	}
}
