//
//  PNCommon.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit

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