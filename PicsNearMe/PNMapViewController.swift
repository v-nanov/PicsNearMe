//
//  ViewController.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import UIKit
import MapKit

class PNMapViewController: UIViewController, MKMapViewDelegate, PNMapSliderViewProtocol {

	@IBOutlet var mapView: MKMapView!
	@IBOutlet var sliderView: PNMapSliderView!
	
	var photoManager = PNInstagramPhotoManager.sharedInstance
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		
		let gesture = UITapGestureRecognizer(target: self, action: "tappedMap:")
		self.view.addGestureRecognizer(gesture)
	}
	
	func tappedMap(sender: UITapGestureRecognizer) {
		let touchPoint = sender.locationInView(mapView)
		let locationTouched = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
		// Clear previous pins
		
		// pin drop animation
		
		// Get photos
		photoManager.currentLocation = locationTouched
		photoManager.radius = UInt(sliderView.slider.value)
		performSegueWithIdentifier(typeAsString(PNCollectionViewController), sender: self)
	}

	func sliderValueChanged(value: Meter) {
		photoManager.radius = UInt(value.value)
	}
}

