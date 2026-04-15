//
//  DownloadCellView.swift
//  ImageShow
//
//  Created by Anton Grishin on 14.04.2026.
//
import UIKit

final class DownloadCellView: UIView & UIContentView {
	var downloadConfiguration: DownloadConfiguration {
		get { configuration as! DownloadConfiguration }
		set { configuration = newValue }
	}
	
	var configuration: any UIContentConfiguration {
		didSet {
			updateWithNewConfiguration()
		}
	}
	private lazy var activity: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .large)
		addSubview(view)
		view.fitToSuperview()
		view.hidesWhenStopped = true
		return view
	}()
	
	init(configuration: DownloadConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		updateWithNewConfiguration()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is DownloadConfiguration
	}
}

private extension DownloadCellView {
	func updateWithNewConfiguration() {
		activity.startAnimating()
	}
}
