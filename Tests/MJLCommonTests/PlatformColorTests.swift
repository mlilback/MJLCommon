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
	
	func testCreateViaHex() {
		let color = NSColor(red: 0, green: 0.5, blue: 0.5, alpha: 0.5)
		let hcolor = PlatformColor(rgbaHexString: "007f7f99")
		XCTAssertEqual(color, hcolor)
	}
	
	func testHexString() {
		let color = NSColor(red: 0.5, green: 0.5, blue: 0, alpha: 1.0)
		XCTAssertEqual(color.hexString, "7F7F00")
		let color2 = NSColor(red: 0.5, green: 0.5, blue: 0, alpha: 0.6)
		XCTAssertEqual(color2.hexString, "7F7F0099")
	}
}
