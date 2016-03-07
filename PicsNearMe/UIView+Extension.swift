//
//  UIView+Extension.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

extension UIView {
	func addViewFromNib(nibName: String) {
		let b = NSBundle.init(forClass: self.dynamicType)
		let nib = UINib(nibName: nibName, bundle: b).instantiateWithOwner(self, options: nil)[0] as! UIView
		self.addSubview(nib)
		nib.translatesAutoresizingMaskIntoConstraints = false
		self.leadingAnchor.constraintEqualToAnchor(nib.leadingAnchor).active = true
		self.trailingAnchor.constraintEqualToAnchor(nib.trailingAnchor).active = true
		self.topAnchor.constraintEqualToAnchor(nib.topAnchor).active = true
		self.bottomAnchor.constraintEqualToAnchor(nib.bottomAnchor).active = true
	}
}