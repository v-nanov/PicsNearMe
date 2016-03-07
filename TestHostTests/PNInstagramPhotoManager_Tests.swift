//
//  PNInstagramPhotoManager_Tests.swift
//  PicsNearMe
//
//  Created by Derrick  Ho on 3/7/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

import XCTest
@testable import TestHost

class PNInstagramPhotoManager_Tests: XCTestCase {
	
	var sut = PNInstagramPhotoManager.sharedInstance
	var mockURLSession = Mock_URLSession()
	
    override func setUp() {
        super.setUp()
		sut.urlSession = mockURLSession
    }

    func test_getPhotosInAreaSuccess() {
		
		let expectation = expectationWithDescription("")
		sut.getPhotosInArea { (photos) -> () in
			expectation.fulfill()
		}
		
		let data = try! NSJSONSerialization.dataWithJSONObject(mockDataJson, options: [])
		mockURLSession._completionHandler(data, nil, nil)
		
		waitForExpectationsWithTimeout(3) { (err) -> Void in
			XCTAssertEqual(self.sut.recentPhotos.count, 1)
			XCTAssertEqual(self.sut.recentPhotos[0].username, mockPhotoData_good["user"]!["username"])
		}
	}

}
