//
//  PlatformColorTests.swift
//
//  Created by Mark Lilback on 1/15/18.
//

import XCTest
import Cocoa
@testable import MJLCommon

class PlatformColorTests: XCTestCase {
	func testBasicColor() {
		let color = NSColor(red: 0, green: 1.0, blue: 0, alpha: 1.0)
		let hcolor = PlatformColor(hexString: "00ff00")
		XCTAssertEqual(color, hcolor)
		// test hex string created properly
		let hexstr = color.hexString
		let color2 = PlatformColor(hexString: hexstr)
		XCTAssertEqual(color, color2)
	}
}
