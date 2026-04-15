//
//  GalleryViewController.swift
//  ImageShow
//
//  Created by Anton Grishin on 13.04.2026.
//

import UIKit

final class GalleryViewController: UIViewController {
	private var collectionView: ImageShowCollectionView!
	var startIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView = ImageShowCollectionView.instance(as: .gallery)
		
		view.addSubview(collectionView)
		collectionView.isPagingEnabled = false
		collectionView.fitToSuperview()
		collectionView.contentInsetAdjustmentBehavior = .never
		collectionView.contentInset = .zero
		collectionView.delegate = self
		collectionView.backgroundColor = .clear
	}
	
	@IBAction func share(_ sender: Any) {
		let centerPoint = CGPoint(x: collectionView.frame.midX, y: collectionView.frame.midY)
		guard let indexPath = collectionView.indexPathForItem(at: centerPoint),
			let url = collectionView.imageDataSource
			.urls(for: [indexPath])
			.first
		else {
			return
		}
		let openInBrowser = OpenInBrowserActivity(url: url)
		let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [openInBrowser])
				
		if let popoverController = activityViewController.popoverPresentationController {
			popoverController.sourceView = self.view
			popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
			popoverController.permittedArrowDirections = []
		}
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	@IBAction func onTap(_ sender: Any) {
		guard let navigationController else { return }
		var hide = navigationController.isNavigationBarHidden
		hide.toggle()
		navigationController.setNavigationBarHidden(hide, animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let indexPath = IndexPath(item: startIndex, section: 0)
		collectionView.layoutIfNeeded()
		collectionView.scrollToItem(
			at: indexPath,
			at: .centeredHorizontally,
			animated: false
		)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		let centerPoint = CGPoint(x: collectionView.frame.midX, y: collectionView.frame.midY)
		let indexPath = collectionView.indexPathForItem(at: centerPoint)
		collectionView.isScrollEnabled = false
		coordinator.animate(alongsideTransition: { [weak self] _ in
			guard
				let self = self,
				let indexPath
			else {
				return
			}
			self.collectionView.collectionViewLayout.invalidateLayout()
			self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
			self.view.setNeedsLayout()
			self.view.layoutIfNeeded()
		}) { [weak self] _ in
			self?.collectionView.isScrollEnabled = true
		}
	}
}

extension GalleryViewController: UICollectionViewDelegate {
}
