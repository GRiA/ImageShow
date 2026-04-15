//
//  ViewController.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

class ListViewController: UIViewController {

	private var collectionView: ImageShowCollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView = ImageShowCollectionView.instance(as: .list)
		view.addSubview(collectionView)
		collectionView.fitToSuperview()
		collectionView.delegate = self
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			segue.identifier == .showImageSegue,
			let dstVC = segue.destination as? GalleryViewController,
			let indexPath = sender as? IndexPath
		else {
			return
		}
		dstVC.startIndex = indexPath.row
	}
}

extension ListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard
			let item = self.collectionView.imageDataSource[indexPath.row],
			case .image = item
		else {
			return
		}
		performSegue(withIdentifier: .showImageSegue, sender: indexPath)
	}
}

private extension String {
	static let showImageSegue = "showImage"
}
