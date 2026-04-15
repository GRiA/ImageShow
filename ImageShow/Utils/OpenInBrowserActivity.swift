//
//  OpenUrlButton.swift
//  ImageShow
//
//  Created by Anton Grishin on 15.04.2026.
//

import UIKit

class OpenInBrowserActivity: UIActivity {
	let url: URL
	
	init(url: URL) {
		self.url = url
		super.init()
	}
	
	override var activityTitle: String? { "Open in browser" }
	override var activityType: UIActivity.ActivityType? { UIActivity.ActivityType("com.yourapp.openInBrowser") }
	override var activityImage: UIImage? { UIImage(systemName: "safari") }
	
	override func canPerform(withActivityItems activityItems: [Any]) -> Bool { true }
	
	override func perform() {
		UIApplication.shared.open(url)
		activityDidFinish(true)
	}
}
