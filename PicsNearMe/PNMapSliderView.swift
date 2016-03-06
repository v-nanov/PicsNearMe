//
//  PNMapSliderView.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/5/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit

protocol PNMapSliderViewProtocol: class {
	func sliderValueChanged(value: Meter)
}

@IBDesignable
class PNMapSliderView: UIView {
	let nibName = typeAsString(PNMapSliderView)
	
	@IBOutlet var distanceLabel: UILabel!
	@IBOutlet var slider: UISlider!
	
	weak var sliderDelegate: PNMapSliderViewProtocol?
	
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
		setDistance(Meter(value: Double(slider.value)))
	}
	
	func setDistance(meters: Meter) {
		distanceLabel.text = "Distance \(UInt(meters.value)) m"
	}
	
	@IBAction func sliderValueChanged(sender: UISlider) {
		let meters = Meter(value:Double(sender.value))
		setDistance(meters)
		sliderDelegate?.sliderValueChanged(meters)
	}
}
