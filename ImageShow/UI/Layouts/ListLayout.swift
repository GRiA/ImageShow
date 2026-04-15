//
//  ListLayout.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

final class ListLayout: UICollectionViewCompositionalLayout {
	init() {
		super.init { section, _ in
			let count = CGFloat.preferedItemsCount
			let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0 / count)
			let itemSize = NSCollectionLayoutSize(
				widthDimension: itemWidth,
				heightDimension: itemWidth
			)
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			item.contentInsets = NSDirectionalEdgeInsets(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
			
			let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(100.0)
			)
			
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
			
			let section = NSCollectionLayoutSection(group: group)
			return section
		}
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Unsupported method")
	}
}

extension CGFloat {
	static var preferedItemsCount: CGFloat {
		UIDevice.current.userInterfaceIdiom == .pad ? preferedIPadItemsCount : preferedPhoneItemsCount
	}
	
	static var preferedIPadItemsCount: CGFloat {
		UIDevice.current.orientation.isLandscape ? 7.0 : 5.0
	}
	
	static var preferedPhoneItemsCount: CGFloat {
		UIDevice.current.orientation.isLandscape ? 4.0 : 3.0
	}
}
