//
//  Meter_Tests.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import XCTest
@testable import TestHost

class Meter_Tests: XCTestCase {

	func test_conversionMeterToKM() {
		let tcs = [
			(m: -1000.0, km: -1.0),
			(m: -10.0, km: -0.010),
			(m: 0.0, km: 0.0),
			(m: 10.0, km: 0.010),
			(m: 1000.0, km: 1.0)
		]
		
		for (i,v) in tcs.enumerate() {
			let sut = Meter(value: v.m)
			XCTAssertEqual(sut.value, v.m, "\(i) failed")
			
			XCTAssertEqual(sut.kilometer, v.km, "\(i) failed")
		}
	}
	
}
