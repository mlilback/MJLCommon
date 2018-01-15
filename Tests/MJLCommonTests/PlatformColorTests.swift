//
//  PlatformColorTests.swift
//
//  Created by Mark Lilback on 1/15/18.
//

import XCTest
import Cocoa
@testable import MJLCommon

class PlatformColorTests: XCTestCase {
	func testEquality() {
		let color = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.67)
		XCTAssertTrue(color.equals(PlatformColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 0.68)))
		XCTAssertFalse(color.equals(PlatformColor(red: 0.45, green: 0.49, blue: 0.49, alpha: 0.68)))
	}
	
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
		let color = NSColor(red: 0, green: 0.5, blue: 0.5, alpha: 0.6)
		let hexColor = PlatformColor(hexString: "007f7f99")
		guard let hcolor = hexColor else { XCTFail("failed to create hex color"); return }
		XCTAssertTrue(hcolor.equals(color, accuracy: 0.01))
	}
	
	func testHexString() {
		let color = NSColor(red: 0.5, green: 0.5, blue: 0, alpha: 1.0)
		XCTAssertEqual(color.hexString, "7F7F00")
		let color2 = NSColor(red: 0.5, green: 0.5, blue: 0, alpha: 0.6)
		XCTAssertEqual(color2.hexString, "7F7F0099")
	}
}
