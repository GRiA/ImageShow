//
//  ImageShowCollectionView.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

public enum Mode {
	case list
	case gallery
}

final class ImageShowCollectionView: UICollectionView {
	public private(set) var imageDataSource: ImageDataSource! {
		didSet {
			dataSource = imageDataSource
		}
	}
	static func instance(as mode: Mode) -> ImageShowCollectionView {
		let layout = mode == .list ? ListLayout() : GalleryLayout()
		let collection = ImageShowCollectionView(
			frame: .zero,
			collectionViewLayout: layout
		)
		collection.imageDataSource = ImageDataSource(collectionView: collection, mode: mode)
		return collection
	}
}

