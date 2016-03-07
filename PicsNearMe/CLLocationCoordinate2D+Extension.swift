//
//  CLLocationCoordinate2D.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

extension CLLocationCoordinate2D {
	func distanceTo(coord: CLLocationCoordinate2D) -> Meter {
		let x0 = CLLocation(latitude: self.latitude, longitude: self.longitude)
		let x1 = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
		return Meter(value: x0.distanceFromLocation(x1))
	}
}