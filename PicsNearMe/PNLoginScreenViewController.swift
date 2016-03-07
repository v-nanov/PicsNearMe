//
//  PNLoginScreenViewController.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/5/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit

class PNLoginScreenViewController: UIViewController {
	
	@IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var instagramSessionManager = PNInstagramSessionManager.sharedInstance
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor(patternImage: PNImages.LoginBackgroundPattern.image)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		instagramSessionManager.logout()
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.activityIndicator.startAnimating()
		self.webView.hidden = true
		instagramSessionManager.loadLogin(webView,
			pageFinishedLoading: { [unowned self] () -> () in
				var currentWVSize = self.webView.frame.size
				currentWVSize.height = 0
				
				self.formatWebView(currentWVSize)
				self.webView.hidden = false
				self.activityIndicator.stopAnimating()
			}, completion: { [unowned self] (success) -> () in
				let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier(typeAsString(PNMapViewController))
				let nav = UINavigationController(rootViewController: destinationVC)
				self.presentViewController(nav, animated: true, completion: nil)
			})
		
	}
	
	func formatWebView(size: CGSize) {
		let sizeBasedContent = self.webView.sizeThatFits(size)
		self.webViewHeightConstraint.constant = sizeBasedContent.height
		
		webView.layer.shadowColor = UIColor.blackColor().CGColor
		webView.layer.shadowOffset = CGSize(width: 0, height: 5)
		webView.layer.masksToBounds = false
		webView.layer.shadowRadius = 5
		webView.layer.shadowOpacity = 0.5
	}
}
