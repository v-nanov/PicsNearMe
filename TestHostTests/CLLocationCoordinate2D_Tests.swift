//
//  CLLocation.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import XCTest
@testable import TestHost

class CLLocationCoordinate2D_Tests: XCTestCase {
	let accuracy = 0.000001
	
	func test_equalCoordinates() {
		let a = CLLocationCoordinate2D()
		
		let dist = a.distanceTo(a)
		XCTAssertEqualWithAccuracy(dist.value, 0.0, accuracy: accuracy)
		
		let b = CLLocationCoordinate2D()
		
		let dist2 = a.distanceTo(b)
		XCTAssertEqualWithAccuracy(dist2.value, 0.0, accuracy: accuracy)
	}

	func test_DifferentCoordinates() {
		let a = CLLocationCoordinate2D(latitude: 50, longitude: 2)
		let b = CLLocationCoordinate2D(latitude: 76, longitude: 5)
		
		let dist2 = a.distanceTo(b)
		XCTAssertEqualWithAccuracy(dist2.value, 2900825.03478675, accuracy: accuracy)
	}
}
