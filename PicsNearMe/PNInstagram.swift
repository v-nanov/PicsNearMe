//
//  PNInstagram.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit
import MapKit

class PNInstagramPhotoManager {
	var currentLocation = CLLocationCoordinate2D(latitude: 48.858844, longitude: 2.294351)
	var radius = UInt(100)
	
	func getPhotosInArea() {
		let str = "\(BASE_URL)\(QUERY_TYPE)?distance=\(radius)&lat=\(currentLocation.latitude)&lng=\(currentLocation.longitude)&access_token=\(ACCESS_TOKEN)"
		print(str)
		if let url = NSURL(string: str) {
			NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (d: NSData?, res: NSURLResponse?, err: NSError?) -> Void in
				print("taskReturned")
				guard err == nil,
					let data = d
					else {
						print("error")
						return
				}
				print(String(data: data, encoding: NSUTF8StringEncoding))
				print("done")
			}).resume()
		}
	}
}
