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
	
	/// if url does not exist, returns url. Otherwise, iterates adding an incrementing number (starting at 1) until the file does not exist
	/// - Parameter url: desired URL to save a file to
	/// - Returns: url, or the first incremented name that does not exist (e.g. "File 1.txt", "File 2.txt")
	func uniquedName(for url: URL) -> URL {
		guard url.fileExists() else { return url }
		let baseUrl = url.deletingLastPathComponent()
		let ext = url.pathExtension
		let baseFileName = url.deletingPathExtension().lastPathComponent
		var num = 1
		var nextFile = url
		repeat {
			nextFile = baseUrl.appendingPathComponent("\(baseFileName) \(num).\(ext)")
			num += 1
		} while (nextFile.fileExists())
		return nextFile
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

