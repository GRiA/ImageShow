//
//  ImageDataSource.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

enum CellType: Hashable {
	case image(URL)
	case download(Float)
	case unknown(String)
	case error(String, URL)
}

final class ImageDataSource: UICollectionViewDiffableDataSource<String, Int> {
	private let imageCellRegistration = UICollectionView.imageCellRegistration
	private let downloadCellRegistration = UICollectionView.downloadCellRegistration
	private let unknownCellRegistration = UICollectionView.unknownCellRegistration
	private let errorCellRegistration = UICollectionView.errorCellRegistration
	
	private var cellTypes: [CellType] = ItemService.shared.items
	private let mode: Mode
	
	init(collectionView: UICollectionView, mode: Mode) {
		self.mode = mode
		super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
			guard
				let dataSource = collectionView.dataSource as? ImageDataSource
			else {
				return nil
			}
			let cellRegistration = dataSource.cellRegistration(for: indexPath.row)
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
			cell.contentConfiguration = dataSource.configuration(for: indexPath.row)
			return cell
		}
		ItemService.shared.addDelegate(self)
		update()
	}
	
	deinit {
		ItemService.shared.removeDelegate(self)
	}
	
	subscript(_ index: Int) -> CellType? {
		guard
			cellTypes.indices.contains(index)
		else {
			return nil
		}
		return cellTypes[index]
	}
	
	func urls(for indexPaths: [IndexPath]) -> [URL] {
		indexPaths.compactMap {
			guard cellTypes.indices.contains($0.row) else { return nil }
			switch cellTypes[$0.row] {
				case .image(let url): return url
				default: return nil
			}
		}
	}
	
}

private extension ImageDataSource {
	func cellRegistration(for index: Int) -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
		guard
			cellTypes.indices.contains(index)
		else {
			fatalError("Invalid index")
		}
		let cellType = cellTypes[index]
		switch cellType {
			case .image(let url):
				let size: ImageService.ImageSize = mode == .gallery ? .full : .preview
				if let _ = ImageService.shared?.cachedImage(from: url, with: size) {
					return imageCellRegistration
				}
				fallthrough
			case .download:
				return downloadCellRegistration
			case .error: return errorCellRegistration
			case .unknown: return unknownCellRegistration
		}
	}
	
	func configuration(for index: Int) -> UIContentConfiguration? {
		guard
			cellTypes.indices.contains(index)
		else {
			return nil
		}
		let cellType = cellTypes[index]
		switch cellType {
			case .image(let url):
				let size: ImageService.ImageSize = mode == .gallery ? .full : .preview
				if let image = ImageService.shared?.cachedImage(from: url, with: size) {
					return ImageConfiguration(mode: mode, image: image)
				}
				Task {
					do {
						let _ = try await ImageService.shared?.fetchImage(from: url, with: mode == .gallery ? .full : .preview)
					} catch {
						cellTypes[index] = .error(error.localizedDescription, url)
					}
					reloadItems([index])
				}
				fallthrough
			case .download:
				return DownloadConfiguration(text: "Loading...")
			case .unknown(let text):
				return TextConfiguration(text: text)
			case let .error(text, url):
				let config = ErrorConfiguration(text: text, url: url)
				config.retryAction = { [weak self] in
					guard let self else { return }
					self.cellTypes[index] = .image($0)
					self.reloadItems([index])
				}
				return config
		}
	}
	
	func reloadItems(_ indexSet: [Int]) {
		var snapshot = snapshot()
		snapshot.reloadItems(indexSet)
		apply(snapshot, animatingDifferences: true)
	}
}

extension ImageDataSource: ItemServiceDelegate {
	func update() {
		self.cellTypes = ItemService.shared.items
		var snapshot = snapshot()
		if snapshot.sectionIdentifiers.isEmpty {
			snapshot.appendSections([.sectionName])
		}
		snapshot.appendItems(
			self.cellTypes.enumerated().map { index, _ in index },
			toSection: .sectionName
		)
		
		apply(snapshot)
	}
	
	func check() {
		cellTypes.enumerated().forEach {
			if case let .error(_, url) = $1 {
				cellTypes[$0] = .image(url)
			}
		}
	}
}

private extension String {
	static let sectionName = "Images"
}
