//
//  TextConfiguration.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

final class TextConfiguration: UIContentConfiguration {
	private(set) var text: String?
	
	init(text: String? = nil) {
		self.text = text
	}
	
	func makeContentView() -> any UIView & UIContentView {
		TextCellView(configuration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		return self
	}
}
