//
//  PNInstagramPhotoManager.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

protocol FlaggedPic: class {
	var instagramID: String { get set }
}

extension FlaggedPic where Self: CKRecord {
	/** Creates a ALLSnackProtocol conforming Object*/
	static func initWithFlaggedPic(withRecordID recordID: String? = nil) -> FlaggedPic {
		if let recordID = recordID {
			return CKRecord(recordType: "FlaggedPic", recordID: CKRecordID(recordName: recordID))
		} else {
			return CKRecord(recordType: "FlaggedPic")
		}
	}
}

extension CKRecord: FlaggedPic {
	public var instagramID: String {
		get { return self["InstagramID"] as! String }
		set { self["InstagramID"] = newValue }
	}
}

/////

class PNInstagramPhotoManager {
	
	static let sharedInstance = PNInstagramPhotoManager()
	var urlSession = NSURLSession.sharedSession()
	var standardUserDefaults = NSUserDefaults.standardUserDefaults()
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
			// query for Flagged
			
			let query = CKQuery(recordType: "FlaggedPic", predicate: NSPredicate(value: true))
			let group = dispatch_group_create()
			dispatch_group_enter(group)
			var isLoggedIn = false
			CKContainer.defaultContainer().publicCloudDatabase
				.performQuery(query,
				              inZoneWithID: nil,
				              completionHandler: { (records: [CKRecord]?, err: NSError?) in
								guard err == nil else {
									dispatch_group_leave(group)
									// if you aren't signed in you can't fetch from the pubic database
									// how to verify login?
									print(err)
									let alert = UIAlertView(title: "Login needed", message: "Please login to iCloud and try again later", delegate: nil, cancelButtonTitle: "OK")
									dispatch_async(dispatch_get_main_queue(), alert.show)
									return
								}
								let pixs: [FlaggedPic] = records?.map({ $0 as FlaggedPic }) ?? []
								print(pixs)
								pixs.forEach({ self.standardUserDefaults.setBool(true, forKey: $0.instagramID) })
								isLoggedIn = true
								dispatch_group_leave(group)
				})
			
			dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 100.0)))
			guard isLoggedIn  else {
				_completion([])
				return
			}
			urlSession.dataTaskWithURL(url, completionHandler: { (d: NSData?, res: NSURLResponse?, err: NSError?) -> Void in
				guard err == nil,
					let data = d,
					let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [String:AnyObject],
					let photoObjs = json["data"] as? [[String:AnyObject]]
					else {
						_completion([])
						return
				}
				self.recentPhotos = photoObjs.map(PNInstagramPhotoModel.init).map(self.markFlaggedPhotosNonVisible).sort({ (left, right) -> Bool in
					switch (left.visible, right.visible) {
					case (true, false):
						return true
					case (false, true):
						return false
					default:
						let a = left.location.distanceTo
						let b = right.location.distanceTo
						return a(self.currentLocation).value < b(self.currentLocation).value
					}
				})
				_completion(self.recentPhotos)
			}).resume()
		}
	}
	
	func markFlaggedPhotosNonVisible(model: PNInstagramPhotoModel) -> PNInstagramPhotoModel {
		var model = model
		model.visible = standardUserDefaults.boolForKey(model.id) == false // if the photo id is not found make visible true
		return model
	}
}
