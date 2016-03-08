//
//  PNInstagramSessionManager.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

class PNInstagramSessionManager: NSObject , UIWebViewDelegate {
	
	static let sharedInstance:PNInstagramSessionManager = PNInstagramSessionManager()
	
	var urlSession = NSURLSession.sharedSession()
	var sessionID: String = "3016601242.1677ed0.dbfa2e13573e40c0bfb6dd987a329f64"
	
	private var loginCompletion = { (success: Bool) -> () in }
	private var pageFinishedLoading = { () -> () in }
	
	func logout() {
		let session = urlSession.dataTaskWithRequest(NSURLRequest(URL: NSURL(string: PNInstagramConstants.LOGOUT.rawValue)!)) { _,_,_ in
		}
		session.resume()
	}
	
	func loadLogin(webView: UIWebView, pageFinishedLoading: () -> (), completion: (success: Bool) -> ()) {
		webView.delegate = self
		loginCompletion = completion
		self.pageFinishedLoading = pageFinishedLoading
		
		let loginComponent = NSURLComponents(string: PNInstagramConstants.AUTH_URL.rawValue)!
		
		loginComponent.queryItems = [
			NSURLQueryItem(name: "client_id", value: PNInstagramConstants.CLIENT_ID.rawValue),
			NSURLQueryItem(name: "redirect_uri", value: PNInstagramConstants.REDIRECT_URI.rawValue),
			NSURLQueryItem(name: "response_type", value: "token")
		]
		
		let request = NSMutableURLRequest(URL: loginComponent.URL!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: NSTimeInterval(PNInstagramConstants.TimeOut.rawValue)!)
		
		request.HTTPMethod = "POST"
		
		webView.loadRequest(request)
	}
	
	// MARK: - webview delegate
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let components = NSURLComponents(URL: request.URL!, resolvingAgainstBaseURL: false)!
		if let accessFragment: NSString = components.fragment {
			let m = accessFragment.rangeOfString("access_token=")
			if m.location != NSNotFound {
				self.sessionID = accessFragment.substringFromIndex(m.location + m.length)
				webView.stopLoading()
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					self.loginCompletion(true)
				})
				return false
			}
		}
		return true
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		self.pageFinishedLoading()
	}
	
}
