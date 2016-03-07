//
//  PNDownloadManager.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

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
