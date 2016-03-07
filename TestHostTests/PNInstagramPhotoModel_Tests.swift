//
//  TestHostTests.swift
//  TestHostTests
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import XCTest
@testable import TestHost

class PNInstagramPhotoModel_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func test_Empty() {
		let sut = PNInstagramPhotoModel(dict: [:])
		XCTAssertEqual(sut.username, "")
		XCTAssertEqual(sut.location.latitude, 0.0)
		XCTAssertEqual(sut.location.longitude, 0.0)
		XCTAssertEqual(sut.photoURL.absoluteString, "")
	}
	
	func test_Ideal() {
		let sut = PNInstagramPhotoModel(dict: [
			"location" : [
				"latitude" : 40.0,
				"longitude" : 40.0
			],
			"images" : [
				"thumbnail" : [
					"url" : "http://placekitten.com.s3.amazonaws.com/homepage-samples/200/287.jpg"
				],
			],
			"user" : [
				"username" : "Kitten"
			],
		])
		
		XCTAssertEqual(sut.username, "Kitten")
		XCTAssertEqual(sut.location.latitude, 40.0)
		XCTAssertEqual(sut.location.longitude, 40.0)
		XCTAssertEqual(sut.photoURL.absoluteString, "http://placekitten.com.s3.amazonaws.com/homepage-samples/200/287.jpg")
		
	}
	
	func test_LocationTypeWrong() {
		let sut = PNInstagramPhotoModel(dict: [
			"location" : [
				"latitude" : "40.0",
				"longitude" : "40.0"
			],
			"images" : [
				"thumbnail" : [
					"url" : "http://placekitten.com.s3.amazonaws.com/homepage-samples/200/287.jpg"
				],
			],
			"user" : [
				"username" : "Kitten"
			],
			])
		
		XCTAssertEqual(sut.username, "Kitten")
		XCTAssertNotEqual(sut.location.latitude, 40.0)
		XCTAssertNotEqual(sut.location.longitude, 40.0)
		XCTAssertEqual(sut.photoURL.absoluteString, "http://placekitten.com.s3.amazonaws.com/homepage-samples/200/287.jpg")
		
	}

}
