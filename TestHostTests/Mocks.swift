//
//  SingletonMocks.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import Foundation

let mockDataJson = [
	"data" : [mockPhotoData_good]
]

let mockPhotoData_good = [
	"location" : [
		"latitude" : 40.0,
		"longitude" : 40.0
	],
	"images" : [
		"thumbnail" : [
			"url" : "http://placekitten.com.s3.amazonaws.com/homepage-samples/200/287.jpg"
		],
	],
	"user" : [
		"username" : "Kitten"
	],
]

class Mock_URLSessionDataTask: NSURLSessionDataTask {
	var resume_ = { () -> () in
		let d = try! NSJSONSerialization.dataWithJSONObject([], options: [])
		Mock_URLSession.sharedSession()._completionHandler(d, nil, nil)
	}
	
	override func resume() {
		resume_()
	}
}

class Mock_URLSession: NSURLSession {
	static let _sharedSession = Mock_URLSession()
	override class func sharedSession() -> Mock_URLSession {
		return _sharedSession
	}
	
	var _completionHandler = { (d: NSData?, r: NSURLResponse?, e: NSError?) -> Void in }
	
	override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
		let dt = Mock_URLSessionDataTask()
		self._completionHandler = completionHandler
		return dt
	}
}

