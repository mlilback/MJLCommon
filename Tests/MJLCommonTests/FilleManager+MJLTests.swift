//
//  FileManager+MJLTests.swift
//  
//
//  Created by Mark Lilback on 11/11/19.
//

import XCTest
import Cocoa
@testable import MJLCommon

class FIleManagerTests: XCTestCase {
	let fm = FileManager()
	var tmpDir: URL! = nil
	
	override func setUp() {
		tmpDir = try! fm.createTemporaryDirectory()
	}
	
	override func tearDown() {
		try! fm.removeItem(at: tmpDir)
	}
	
	func testUniqueFileName() throws {
		let baseName = "file"
		let ext = "txt"
		let desiredFile = tmpDir.appendingPathComponent("\(baseName).\(ext)")
		var retUrl = fm.uniquedName(for: desiredFile)
		XCTAssertEqual(desiredFile, retUrl)
		try "foo".write(to: desiredFile, atomically: true, encoding: .utf8)
		retUrl = fm.uniquedName(for: desiredFile)
		XCTAssertEqual("file 1.txt", retUrl.lastPathComponent)
		try "foo".write(to: desiredFile.deletingLastPathComponent().appendingPathComponent("file 1.txt"), atomically: true, encoding: .utf8)
		retUrl = fm.uniquedName(for: desiredFile)
		XCTAssertEqual("file 2.txt", retUrl.lastPathComponent)
	}
}
