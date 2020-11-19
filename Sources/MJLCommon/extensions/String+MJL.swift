//
//  String+MJL
//
//  Copyright ©2016 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

public extension String {
	/// Returns the range that encompases the entire string
	var fullRange: Range<Index> { return startIndex..<endIndex }
	
	/// Returns the NSRange that encompases the entire string
	var fullNSRange: NSRange { return NSRange(location: 0, length: utf16.count) }

	/// Converts an NSRange to a Range<String.Index>
	///
	/// - parameter nsRange: the NSRange to convert
	///
	/// - returns: the matching string range
	@available(*, deprecated, message: "use Range(nsrange: in:)")
	func range(from nsRange: NSRange) -> Range<String.Index>? {
		guard
			let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
			let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
			let from = String.Index(from16, within: self),
			let to = String.Index(to16, within: self)
			else { return nil }
		return from ..< to
	}

	/// retrieve the substring represented by an NSRange
	///
	/// - parameter from: the desired range
	///
	/// - returns: the substring, or nil if the range is invalid
	func substring(from: NSRange) -> String? {
		guard let range = range(from: from) else { return nil }
		return String(self[range])
	}

	/// Returns self with string removed from the end (if present)
	///
	/// - Parameter string: the string to remove from the end
	/// - Returns: self with string removed from the end
	func truncate(string: String) -> String {
		guard hasSuffix(string) else { return self }
		let idx = index(endIndex, offsetBy: -string.count)
		return String(self[..<idx])
	}

	/// Returns self with a specified number of characters removed from the end
	///
	/// - Parameter by: the number of characters to remove from the end
	/// - Returns: self with by characters removed from the end
	func truncate(by: Int) -> String {
		guard count > by else { return self }
		let idx = index(endIndex, offsetBy: -by)
		return String(self[..<idx])
	}
}
