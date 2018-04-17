//
//  Array+MJL.swift
//
//  Copyright ©2017 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

public extension Array {
	/// Move an element from one index to another
	///
	/// - Parameters:
	///   - from: index of item to move
	///   - to: destination index for item
	mutating func moveElement(from: Int, to: Int) {
		guard to <= count else { fatalError() }
		var destIndex = to
		if destIndex > from { destIndex -= 1 }
		let val = remove(at: from)
		insert(val, at: destIndex)
	}
}
