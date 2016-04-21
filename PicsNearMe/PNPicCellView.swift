//
//  PNPicCellView.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit

@IBDesignable
class PNPicCellView: UICollectionViewCell {
	let nibName = typeAsString(PNPicCellView)
	var uuid = String()
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var distanceLabel: UILabel!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var flag: UILabel!
	
	var username: String {
		get { return self.usernameLabel.text ?? "" }
		set { self.usernameLabel.text = newValue }
	}
	
	var distance: Meter = Meter(value: 0) {
		didSet { self.distanceLabel.text = String(format:"%.3f km", distance.kilometer) }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUp()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setUp()
	}
	
	func setUp() {
		self.addViewFromNib(self.nibName)
	}
	
	func clear() {
		uuid = ""
		imageView.image = nil
		username = ""
		distance = Meter(value: 0)
	}
	
	override func prepareForInterfaceBuilder() {
		self.username = "Derrick123"
		self.distance = Meter(value: 555)
	}
}