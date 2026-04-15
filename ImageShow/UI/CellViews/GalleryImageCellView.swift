//
//  GalleryImageCellView.swift
//  ImageShow
//
//  Created by Anton Grishin on 14.04.2026.
//

import UIKit

final class GalleryImageCellView: UIView & UIContentView {
	var imageConfiguration: ImageConfiguration {
		get { configuration as! ImageConfiguration }
		set { configuration = newValue }
	}
	var configuration: any UIContentConfiguration {
		didSet {
			updateWithNewConfiguration()
		}
	}
	
	private lazy var scrollView: UIScrollView = {
		let view = UIScrollView(frame: .zero)
		addSubview(view)
		view.fitToSuperview()
		view.delegate = self
		view.maximumZoomScale = 3.0
		view.minimumZoomScale = 1.0
		view.contentInsetAdjustmentBehavior = .never
		view.backgroundColor = .clear
		return view
	}()
	
	private lazy var imageView: UIImageView = {
		let view = UIImageView(frame: .zero)
		view.contentMode = .scaleAspectFit
		view.clipsToBounds = true
		view.layer.cornerRadius = 20.0
		scrollView.addSubview(view)
		view.fitWithZoomToSuperview()
		view.backgroundColor = .clear
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

private extension GalleryImageCellView {
	func updateWithNewConfiguration() {
		imageView.image = imageConfiguration.image
		scrollView.zoomScale = 1.0
	}
}

extension GalleryImageCellView: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		imageView
	}
}
