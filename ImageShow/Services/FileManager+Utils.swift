//
//  FileManager+Utils.swift
//  ImageShow
//
//  Created by Anton Grishin on 14.04.2026.
//

import Foundation

extension FileManager {
	nonisolated var imageCacheUrl: URL? {
		get throws {
			guard let cacheUrl = urls(for: .cachesDirectory, in: .userDomainMask)
				.first?
				.appendingPathComponent(.imageCacheFolderName)
			else {
				throw Errors.unableToCreateDirectory
			}
			try? createDirectory(at: cacheUrl, withIntermediateDirectories: true)
			return cacheUrl
		}
	}
	
	nonisolated var previewCacheUrl: URL? {
		get throws {
			guard let  url = try imageCacheUrl else {
				throw Errors.unableToCreateDirectory
			}
			let previewUrl = url.appendingPathComponent(.previewCacheFolderName)
			try? createDirectory(at: previewUrl, withIntermediateDirectories: true)
			return previewUrl
		}
	}
	
	func moveToCache(fileURL: URL, with name: String) throws -> URL {
		let cacheURL = try self.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		let destinationURL = cacheURL.appendingPathComponent(name)
		if fileExists(atPath: destinationURL.path()) {
			try removeItem(at: destinationURL)
		}
		try self.moveItem(at: fileURL, to: destinationURL)
		return destinationURL
	}
}

private extension FileManager {
	enum Errors: Error {
		case unableToCreateDirectory
	}
}

private extension String {
	nonisolated static let imageCacheFolderName: String = "images"
	nonisolated static let previewCacheFolderName: String = "previews"
}
