//
//  DownloadConfiguration.swift
//  ImageShow
//
//  Created by Anton Grishin on 14.04.2026.
//

import UIKit

final class DownloadConfiguration: UIContentConfiguration {
	private(set) var text: String?
	
	init(text: String? = nil) {
		self.text = text
	}
	
	func makeContentView() -> any UIView & UIContentView {
		DownloadCellView(configuration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		return self
	}
}
