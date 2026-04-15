//
//  UICollectionView+Cells.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

extension UICollectionView {
	
	static let imageCellRegistration =  {
		generateCellRegistration(with: .clear)
	}()
	static let downloadCellRegistration = {
		generateCellRegistration(with: .lightGray)
	}()
	static let unknownCellRegistration = {
		generateCellRegistration(with: .darkGray)
	}()
	static let errorCellRegistration = {
		generateCellRegistration(with: .red.withAlphaComponent(0.6))
	}()
}

private extension UICollectionView {
	static func generateCellRegistration(with color: UIColor) -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		UICollectionView.CellRegistration<UICollectionViewCell, Int> { cell, _, _ in
			var background = cell.defaultBackgroundConfiguration()
			background.backgroundColor = color
			background.cornerRadius = 20
			background.strokeColor = .label.withAlphaComponent(0.2)
			background.strokeWidth = 1
			cell.backgroundConfiguration = background
		}
	}
}
