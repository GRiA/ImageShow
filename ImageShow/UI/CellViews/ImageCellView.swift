//
//  ImageView.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

final class ImageCellView: UIView & UIContentView {
	var imageConfiguration: ImageConfiguration {
		get { configuration as! ImageConfiguration }
		set { configuration = newValue }
	}
	var configuration: any UIContentConfiguration {
		didSet {
			updateWithNewConfiguration()
		}
	}
	
	private lazy var imageView: UIImageView = {
		let view = UIImageView(frame: .zero)
		view.contentMode = .scaleAspectFill
		view.clipsToBounds = true
		view.layer.cornerRadius = 20.0
		addSubview(view)
		view.fitToSuperview()
		return view
	}()
	
	init(configuration: ImageConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		updateWithNewConfiguration()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is ImageConfiguration
	}
}

private extension ImageCellView {
	func updateWithNewConfiguration() {
		imageView.image = imageConfiguration.image
	}
}
