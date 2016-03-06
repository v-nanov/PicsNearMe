//
//  PNLoginScreenViewController.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/5/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit

class PNLoginScreenViewController: UIViewController, UIWebViewDelegate {
	
	@IBOutlet var webView: UIWebView!
	
	var loginComponent = NSURLComponents(string: PNInstagramConstants.AUTH_URL.rawValue)!
	
	@IBAction func tappedLoginButton(sender: AnyObject) {
		// perform oauth with instagram
		
		loginComponent.queryItems = [
			NSURLQueryItem(name: "client_id", value: PNInstagramConstants.CLIENT_ID.rawValue),
			NSURLQueryItem(name: "redirect_uri", value: PNInstagramConstants.REDIRECT_URI.rawValue),
			NSURLQueryItem(name: "response_type", value: "token")
		]
		
		let request = NSMutableURLRequest(URL: loginComponent.URL!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: NSTimeInterval(PNInstagramConstants.TimeOut.rawValue)!)
		
		request.HTTPMethod = "POST"
		
		webView.loadRequest(request)
		presentWebView()
		
	}
	
	func presentWebView() {
		self.view.addSubview(webView)
		
		webView.frame = self.view.frame
		
	}
	
	func dismissWebView() {
		webView.removeFromSuperview()
	}
	
	// MARK: - webview delegate
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let components = NSURLComponents(URL: request.URL!, resolvingAgainstBaseURL: false)!
		if let accessFragment: NSString = components.fragment {
			let m = accessFragment.rangeOfString("access_token=")
			if m.location != NSNotFound {
				PNInstagramSessionManager.sharedInstance.sessionID = accessFragment.substringFromIndex(m.location + m.length)
				//dismissWebView()
				
				let destinationVC = storyboard!.instantiateViewControllerWithIdentifier(typeAsString(PNMapViewController))
					showViewController(UINavigationController(rootViewController: destinationVC), sender: self)
//				performSegueWithIdentifier(typeAsString(PNMapViewController), sender: self)
			}
		}
		return true
	}
	
	func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
		// TODO: Error Msg
	}
	
	func webViewDidStartLoad(webView: UIWebView) {
		
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		
	}
}
