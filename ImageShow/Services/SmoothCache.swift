//
//  SmoothCache.swift
//  ImageShow
//
//  Created by Anton Grishin on 14.04.2026.
//

import UIKit

final class SmoothCache: @unchecked Sendable {
	private let cache: NSCache<NSString, UIImage> = {
		let cache = NSCache<NSString, UIImage>()
		cache.countLimit = 100
		return cache
	}()
	
	nonisolated init() {}
	
	nonisolated func get(_ key: String) -> UIImage? {
		cache.object(forKey: key as NSString)
	}
	
	nonisolated func set(_ image: UIImage, for key: String) {
		cache.setObject(image, forKey: key as NSString)
	}
}
