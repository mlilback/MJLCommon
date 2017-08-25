//
//  NSURL+MJL.swift
//
//  Copyright ©2016 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

extension URL {
	/// Returns the localized name of the URL
	///
	/// - Returns: the localized name
	public func localizedName() -> String {
		var appName: String = (self.deletingPathExtension().lastPathComponent)
		do {
			let rsrcs = try resourceValues(forKeys: [.localizedNameKey])
			if let localName = rsrcs.localizedName {
				appName = localName
			}
			//remove any extension
			if let dotIndex = appName.characters.index(of: ".") {
				appName = String(appName[..<dotIndex])
			}
			return appName
		} catch _ {} //don't care if it failed
		return lastPathComponent
	}

	/// calls checkResourceIsReachable and returns false if an error is thrown
	///
	/// - Returns: true if the file exists
	public func fileExists() -> Bool {
		if let exists = try? checkResourceIsReachable() {
			return exists
		}
		return false
	}

	/// calls resourceValues and to check if self is a directory
	///
	/// - Returns: true if this URL represents a directory on the local file system
	public func directoryExists() -> Bool {
		guard isFileURL else { return false }
		if let rsrcs = try? resourceValues(forKeys: [.isDirectoryKey]), let isDir = rsrcs.isDirectory { return isDir }
		return false
	}

	/// Convience method to load data from a file URL
	///
	/// - returns: contents or nil if Data(contentsOf:) throws an error
	public func contents() -> Data? {
		if let data = try? Data(contentsOf: self) { return data }
		return nil
	}

	/// gets the file size without throwing an error.
	/// - returns: the size of the file. returns 0 if the URL is not a file or on an error
	public func fileSize() -> Int64 {
		guard self.isFileURL else { return 0 }
		do {
			let rsrcs = try resourceValues(forKeys: [.fileSizeKey])
			if let size = rsrcs.fileSize {
				return Int64(size)
			}
		} catch _ {}
		return 0
	}
}
