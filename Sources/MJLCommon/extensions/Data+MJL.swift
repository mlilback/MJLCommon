//
//  Data+MJL.swift
//
//  Copyright ©2016 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation
import CommonCrypto

public extension Data {
	/// Initializes Data with the contents of inputStream, read synchronously
	///
	/// - parameter inputStream: The stream to read data from
	/// - parameter bufferSize: the size of the buffer to use while reading from inputStream. Defaults to 1 MB
	init(_ inputStream: InputStream, bufferSize: Int = 10_240) {
		self.init()
		var buffer = [UInt8](repeating: 0, count: bufferSize)
		inputStream.open()
		while inputStream.hasBytesAvailable {
			let readSize = inputStream.read(&buffer, maxLength: bufferSize)
			self.append(&buffer, count: readSize)
		}
		inputStream.close()
	}
	
	/// Calculates a SHA256 checksum
	/// - Returns: the checksum
	func sha256() -> Data {
		var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
		self.withUnsafeBytes {
			_ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &hash)
		}
		return Data(hash)
	}
	
	/// Enumerate through slices of contents divided by a particular data value
	///
	/// - Parameters:
	///   - divider: the data to use as a seperator
	///   - handler: a closure that is passed a matching slice of data
	func enumerateComponentsSeparated(by divider: Data, handler: (Data) -> Void) {
		var start = startIndex
		var remainingRange: Range<Data.Index> = start..<endIndex
		while true {
			guard let divRange = range(of: divider, options: [], in: remainingRange) else
			{
				//no more dividers, just handle remaing range
				if !remainingRange.isEmpty {
					handler(subdata(in: remainingRange))
				}
				return
			}
			let matchRange: Range<Data.Index> = start..<divRange.lowerBound
			handler(subdata(in: matchRange))
			start = matchRange.upperBound + divider.count
			remainingRange = start..<endIndex
		}
	}
}
