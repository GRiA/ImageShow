//
//  TextCellView.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

final class TextCellView: UIView & UIContentView {
	var textConfiguration: TextConfiguration {
		get { configuration as! TextConfiguration }
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
		addSubview(label)
		label.fitToSuperview()
		return label
	}()
	
	init(configuration: TextConfiguration) {
		self.configuration = configuration
		super.init(frame: .zero)
		updateWithNewConfiguration()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
	
	func supports(_ configuration: any UIContentConfiguration) -> Bool {
		configuration is TextConfiguration
	}
}

private extension TextCellView {
	func updateWithNewConfiguration() {
		label.text = textConfiguration.text
	}
}
