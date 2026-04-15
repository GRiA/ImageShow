//
//  UIView+Utils.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

extension UIView {
	func fitToSuperview() {
		guard let superview = superview else { return }
		translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: superview.leadingAnchor),
			trailingAnchor.constraint(equalTo: superview.trailingAnchor),
			topAnchor.constraint(equalTo: superview.topAnchor),
			bottomAnchor.constraint(equalTo: superview.bottomAnchor)
		])
	}
	
	func fitWithZoomToSuperview() {
		guard let superview = superview as? UIScrollView else { return }
		translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
		topAnchor.constraint(equalTo: superview.contentLayoutGuide.topAnchor),
		leadingAnchor.constraint(equalTo: superview.contentLayoutGuide.leadingAnchor),
		trailingAnchor.constraint(equalTo: superview.contentLayoutGuide.trailingAnchor),
		bottomAnchor.constraint(equalTo: superview.contentLayoutGuide.bottomAnchor),
		
		widthAnchor.constraint(equalTo: superview.frameLayoutGuide.widthAnchor),
		heightAnchor.constraint(equalTo: superview.frameLayoutGuide.heightAnchor)
		])
	}
	
	func topOnSuperview() {
		guard let superview = superview else { return }
		translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: superview.leadingAnchor),
			trailingAnchor.constraint(equalTo: superview.trailingAnchor),
			topAnchor.constraint(equalTo: superview.topAnchor, constant: 4)
		])
	}
	
	func after(view: UIView) {
		guard let superview = superview else { return }
		translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: superview.leadingAnchor),
			trailingAnchor.constraint(equalTo: superview.trailingAnchor),
			topAnchor.constraint(equalTo: view.bottomAnchor),
			bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 4)
		])
	}
}
