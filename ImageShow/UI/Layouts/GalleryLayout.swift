//
//  GalleryLayout.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

final class GalleryLayout: UICollectionViewCompositionalLayout {
	init() {
		super.init { sectionIndex, _ in
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0)
			)
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			
			let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0)
			)
			
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
			
			let section = NSCollectionLayoutSection(group: group)
			section.orthogonalScrollingBehavior = .groupPagingCentered
			return section
		}
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
}
