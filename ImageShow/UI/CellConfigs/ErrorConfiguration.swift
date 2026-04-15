//
//  ErrorConfiguration.swift
//  ImageShow
//
//  Created by Anton Grishin on 14.04.2026.
//

import UIKit

final class ErrorConfiguration: UIContentConfiguration {
	private(set) var text: String?
	private let srcUrl: URL
	
	var retryAction: ((URL)->Void)?
	
	init(text: String? = nil, url: URL) {
		self.text = text
		self.srcUrl = url
	}
	
	func makeContentView() -> any UIView & UIContentView {
		ErrorCellView(configuration: self)
	}
	
	func updated(for state: any UIConfigurationState) -> Self {
		return self
	}
	
	func retry() {
		retryAction?(srcUrl)
	}
}
