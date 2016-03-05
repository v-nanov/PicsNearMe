//
//  PNInstagram.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit
import MapKit

struct PNInstagramPhotoModel {
	var photoURL = NSURL()
	var username = String()
	var location = CLLocationCoordinate2D()
	
	init(dict: [String:AnyObject]) {
		for (key, value) in dict {
			switch key {
			case "location":
				if let lat = value["latitude"] as? Double,
					let lng = value["longitude"] as? Double
				{
					location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
				}
			case "images":
				if let thumbnail = value["thumbnail"] as? [String:AnyObject],
					let thumbnailurl = thumbnail["url"] as? String,
					let url = NSURL(string: thumbnailurl)
				{
					photoURL = url
				}
			case "user":
				if let un = value["username"] as? String {
					username = un
				}
			default:()
			}
		}
	}
}

class PNInstagramPhotoManager {
	
	static let sharedInstance = PNInstagramPhotoManager()
	var downloadManager = PNDownloaderManager.sharedInstance
	
	var currentLocation = CLLocationCoordinate2D(latitude: 48.858844, longitude: 2.294351)
	var radius = UInt(100)
	
	var recentPhotos = [PNInstagramPhotoModel]()
	
	func getPhotosInArea(completion: (photos: [PNInstagramPhotoModel]) -> ()) {
		let str = PNInstagramURL.BASE_URL.rawValue +
			PNInstagramURL.QUERY_TYPE.rawValue +
			"?distance=\(radius)" +
			"&lat=\(currentLocation.latitude)" +
			"&lng=\(currentLocation.longitude)" +
		"&access_token=\(PNInstagramURL.ACCESS_TOKEN.rawValue)"
		
		let _completion = { (photoObjs: [PNInstagramPhotoModel]) -> () in
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				completion(photos: photoObjs)
			})
		}
		if let url = NSURL(string: str) {
			NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (d: NSData?, res: NSURLResponse?, err: NSError?) -> Void in
				guard err == nil,
					let data = d,
					let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [String:AnyObject],
				let photoObjs = json["data"] as? [[String:AnyObject]]
					else {
						completion(photos: [])
						return
				}
				self.recentPhotos = photoObjs.map(PNInstagramPhotoModel.init).sort({ (left, right) -> Bool in
					let a = left.location.distanceTo
					let b = right.location.distanceTo
					return a(self.currentLocation).value < b(self.currentLocation).value
				})
				_completion(self.recentPhotos)
				print("done")
			}).resume()
		}
	}
	
}

class PNDownloaderManager {
	static let sharedInstance = PNDownloaderManager()
	let downloaderDispatchQueue = dispatch_queue_create(typeAsString(PNDownloaderManager), DISPATCH_QUEUE_CONCURRENT)
	private let cache = NSCache()
	
	func getImageFromData(data: NSData) throws -> UIImage {
		guard let img = UIImage(data: data) else {
			throw PNError.DataConversionError
		}
		return img
	}
	
	func getImageFromCache(url: NSURL) throws -> UIImage {
		guard let img = cache.objectForKey(url.absoluteString) as? UIImage else {
			throw PNError.CacheFetchError
		}
		return img
	}
	
	func getImageFromURL(url: NSURL) throws -> UIImage {
		guard let data = NSData(contentsOfURL: url) else {
			throw PNError.DownloadError
		}
		
		do {
			let img = try getImageFromData(data)
			cache.setObject(img, forKey: url.absoluteString)
			return img
		} catch let e {
			throw e
		}
	}
	
}
