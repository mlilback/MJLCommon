//
//  NSAttributedString+MJL.swift
//
//  Copyright ©2018 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

public extension NSMutableAttributedString {
	/// Replaces this string with contents
	///
	/// - Parameter contents: An attributed string to set this string's content to
	func replace(with contents: NSAttributedString) {
		deleteCharacters(in: NSRange(location: 0, length: length))
		setAttributedString(contents)
	}

	/// Replaces this string with contents
	///
	/// - Parameter contents: A string to set this string's content to (discarding all attributes)
	func replace(with contents: String) {
		deleteCharacters(in: NSRange(location: 0, length: length))
		setAttributedString(NSAttributedString(string: contents))
	}
}
