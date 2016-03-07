//
//  ViewController.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

class PNMapViewController: UIViewController, MKMapViewDelegate, PNMapSliderViewProtocol, UIAlertViewDelegate {

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
		mapView.removeAnnotations(mapView.annotations)
		// pin drop animation
		let annotation = MKPointAnnotation()
		annotation.coordinate = locationTouched
		
		mapView.addAnnotation(annotation)
		
		// set up photos
		let radius = UInt(sliderView.slider.value)
		photoManager.currentLocation = locationTouched
		photoManager.radius = radius
		
		goToPhotos()
	}

	func sliderValueChanged(value: Meter) {
		photoManager.radius = UInt(value.value)
	}
	
	@IBAction func tappedLogout(sender: AnyObject) {
		let alert = UIAlertView(title: "Logging Out?", message: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Logout")
		alert.show()
	}
	
	func goToPhotos() {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
			self.performSegueWithIdentifier(typeAsString(PNCollectionViewController), sender: self)
		}
	}
	
	// MARK: - UIAlertViewDelegate
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		switch buttonIndex {
		case alertView.cancelButtonIndex:()
		default:
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	// MARK: - MKMapViewDelegate
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
		pinAnnotationView.animatesDrop = true
		return pinAnnotationView
	}
	
}

