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
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(PNMapViewController.tappedMap(_:)))
		self.view.addGestureRecognizer(gesture)
		LocationManager.sharedInstance.locationFound = { (latitude: Double, longitude: Double) -> () in
			print(latitude, longitude)
		}

	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		LocationManager.sharedInstance.autoUpdate = true
		LocationManager.sharedInstance.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) in
			let location = CLLocation(latitude: latitude, longitude: longitude)
			self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
			let annotation = MKPointAnnotation()
			annotation.coordinate = location.coordinate
			
			self.mapView.removeAnnotations(self.mapView.annotations)
			self.mapView.addAnnotation(annotation)
			self.mapView.showAnnotations([annotation], animated: true)
			print(latitude, longitude)
			
			// set up photos
			let radius = UInt(self.sliderView.slider.value)
			self.photoManager.currentLocation = location.coordinate
			self.photoManager.radius = radius
			
			LocationManager.sharedInstance.stopUpdatingLocation()
		}
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
	
	@IBAction func goToPhotos() {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
			self.performSegueWithIdentifier(typeAsString(PNCollectionViewController), sender: self)
		}
	}
		
	// MARK: - MKMapViewDelegate
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
		pinAnnotationView.animatesDrop = true
		return pinAnnotationView
	}
	
}

