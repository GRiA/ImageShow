//
//  ImageConfig.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

final class ImageConfiguration: UIContentConfiguration {
	private(set) var image: UIImage?
	private let mode: Mode
	
	init(mode: Mode, image: UIImage? = nil) {
		self.image = image
		self.mode = mode
	}
	
	func makeContentView() -> any UIView & UIContentView {
		mode == .list ? ImageCellView(configuration: self) : GalleryImageCellView(configuration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		return self
	}
}
