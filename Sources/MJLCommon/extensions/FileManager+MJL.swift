//
//  FileManager+MJL.swift
//
//  Copyright ©2016 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

public extension FileManager {
	/// convience method to check if a directory exists
	///
	/// - Parameter at: the URL to check
	/// - Returns: true if there is  directory at the specified URL
	func directoryExists(at: URL) -> Bool {
		var isDir: ObjCBool = false
		return  self.fileExists(atPath: at.absoluteURL.path, isDirectory: &isDir) && isDir.boolValue
	}
	
	/// creates an empty temporary directory
	///
	/// - Returns: URL to a newly created directory
	/// - Throws: any errors from creating the directory
	func createTemporaryDirectory() throws -> URL {
		let tmpDir = temporaryDirectory.appendingPathComponent(UUID().uuidString)
		if fileExists(atPath: tmpDir.path) {
			try removeItem(at: tmpDir)
		}
		try createDirectory(at: tmpDir, withIntermediateDirectories: true, attributes: nil)
		return tmpDir
	}
}

