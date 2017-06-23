//
//  ExpiringCacheTests.swift
//  MJLCommonTests
//
//  Created by Mark Lilback on 6/23/17.
//

import XCTest
@testable import MJLCommon

class ExpiringCacheTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testSubscripting() {
		var cache = ExpiringCache<Int, String>(duration: 60)
		XCTAssertEqual(cache.count, 0)
		cache[1] = "one"
		XCTAssertEqual(cache.count, 1)
		cache[2] = "two"
		XCTAssertEqual(cache.count, 2)
		cache[1] = nil
		XCTAssertEqual(cache.count, 1)
	}
	
	// does some fidding with times, but unit tests aren't suppose to take a long time
	func testExpiring() {
		var cache = ExpiringCache<Int, String>(duration: 0.5)
		cache[1] = "one"
		let expect1 = XCTestExpectation(description: "second value added")
		DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(600)) {
			cache[2] = "two"
			expect1.fulfill()
		}
		wait(for: [expect1], timeout: 1.0)
		XCTAssertEqual(cache.count, 2)
		cache.expire()
		XCTAssertEqual(cache.count, 1)
	}
	
	
}
