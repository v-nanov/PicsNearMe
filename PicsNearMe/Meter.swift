//
//  Meter.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import Foundation

struct Meter {
	let value: Double
	var kilometer: Double { return self.value / 1000.0 }
}