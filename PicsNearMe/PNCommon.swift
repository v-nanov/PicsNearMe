//
//  PNCommon.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit
import MapKit

struct InstagramDistance {
	static let max = Meter(value: 5_000)
	static let min = Meter(value: 5)
}

enum PNInstagramURL: String {
	case BASE_URL = "https://api.instagram.com/"
	case QUERY_TYPE = "v1/media/search"
	case ACCESS_TOKEN = "510573486.ab7d4b6.d8b155be5d1a47c78f72616b4d942e8d"
}

enum PNImages: String {
	case generic_image
	
	var image: UIImage {
		return UIImage(named: self.rawValue) ?? UIImage()
	}
	
	func image(sender: AnyObject) -> UIImage {
		let b = NSBundle(forClass: sender.dynamicType)
		return UIImage(named: self.rawValue, inBundle: b, compatibleWithTraitCollection: nil) ?? UIImage()
	}
}

func typeAsString<T>(type: T.Type) -> String {
	return "\(type)".componentsSeparatedByString(".").last!
}

extension CLLocationCoordinate2D {
	func distanceTo(coord: CLLocationCoordinate2D) -> Meter {
		let x0 = CLLocation(latitude: self.latitude, longitude: self.longitude)
		let x1 = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
		return Meter(value: x0.distanceFromLocation(x1))
	}
}
