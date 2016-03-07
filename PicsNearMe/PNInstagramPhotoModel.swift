//
//  PNInstagramPhotoModel.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

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
				if let thumbnail = value["standard_resolution"] as? [String:AnyObject],
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