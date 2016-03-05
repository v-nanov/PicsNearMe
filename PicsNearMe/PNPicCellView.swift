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
	let nibName = "PNPicCellView"
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var usernameLabel: UILabel!
	@IBOutlet var distanceLabel: UILabel!
	
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
		let b = NSBundle.init(forClass: self.dynamicType)
		if let nib = UINib(nibName: self.nibName, bundle: b).instantiateWithOwner(self, options: nil)[0] as? UIView {
			self.addSubview(nib)
			nib.translatesAutoresizingMaskIntoConstraints = false
			self.leadingAnchor.constraintEqualToAnchor(nib.leadingAnchor).active = true
			self.trailingAnchor.constraintEqualToAnchor(nib.trailingAnchor).active = true
			self.topAnchor.constraintEqualToAnchor(nib.topAnchor).active = true
			self.bottomAnchor.constraintEqualToAnchor(nib.bottomAnchor).active = true
		}
	}
	
	override func prepareForInterfaceBuilder() {
		self.imageView.image = PNImages.generic_image.image(self)
		self.username = "Derrick123"
		self.distance = Meter(value: 555)
	}
}