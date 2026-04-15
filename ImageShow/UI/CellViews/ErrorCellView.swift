//
//  ErrorCellView.swift
//  ImageShow
//
//  Created by Anton Grishin on 14.04.2026.
//

import UIKit

final class ErrorCellView: UIView & UIContentView {
	var errorConfiguration: ErrorConfiguration {
		get { configuration as! ErrorConfiguration }
		set { configuration = newValue }
	}
	
	var configuration: any UIContentConfiguration {
		didSet {
			updateWithNewConfiguration()
		}
	}
	private lazy var label: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.5
		addSubview(label)
		label.topOnSuperview()
		return label
	}()
	
	private lazy var retryButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Retry", for: .normal)
		addSubview(button)
		button.after(view: label)
		button.addTarget(self, action: #selector(retry), for: .touchUpInside)
		return button
	}()
	
	init(configuration: ErrorConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		updateWithNewConfiguration()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is ErrorConfiguration
	}
}

private extension ErrorCellView {
	func updateWithNewConfiguration() {
		label.text = errorConfiguration.text
		retryButton.isHidden = false
	}
	
	@objc func retry() {
		errorConfiguration.retry()
	}
}
