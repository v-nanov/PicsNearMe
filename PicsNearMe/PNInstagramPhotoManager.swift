//
//  PNInstagramPhotoManager.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

class PNInstagramPhotoManager {
	
	static let sharedInstance = PNInstagramPhotoManager()

	var urlSession = NSURLSession.sharedSession()
	var currentLocation = CLLocationCoordinate2D(latitude: 48.858844, longitude: 2.294351)
	var radius = UInt(1000)
	
	var recentPhotos = [PNInstagramPhotoModel]()
	
	func getPhotosInArea(completion: (photos: [PNInstagramPhotoModel]) -> ()) {
		let str = PNInstagramConstants.BASE_URL.rawValue +
			PNInstagramConstants.QUERY_TYPE.rawValue +
			"?distance=\(radius)" +
			"&lat=\(currentLocation.latitude)" +
			"&lng=\(currentLocation.longitude)" +
		"&access_token=\(ACCESS_TOKEN)"
		
		let _completion = { (photoObjs: [PNInstagramPhotoModel]) -> () in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				completion(photos: photoObjs)
			})
		}
		
		if let url = NSURL(string: str) {
			urlSession.dataTaskWithURL(url, completionHandler: { (d: NSData?, res: NSURLResponse?, err: NSError?) -> Void in
				guard err == nil,
					let data = d,
					let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [String:AnyObject],
					let photoObjs = json["data"] as? [[String:AnyObject]]
					else {
						_completion([])
						return
				}
				self.recentPhotos = photoObjs.map(PNInstagramPhotoModel.init).sort({ (left, right) -> Bool in
					let a = left.location.distanceTo
					let b = right.location.distanceTo
					return a(self.currentLocation).value < b(self.currentLocation).value
				})
				_completion(self.recentPhotos)
			}).resume()
		}
	}
	
}
