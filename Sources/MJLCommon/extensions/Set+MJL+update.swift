//
//  Set+MJL+update.swift
//
//  Copyright ©2017 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

public extension Set where Element: AnyObject {
	/// Given:
	/// * a value type `Value`
	/// * a wrapper type `Wrapper`
	/// * `Wrapper` has a property of type `Value` (reached via valueKeyPath)
	/// * `Value` has a property of type `T` that uniquely identifies `Value` objects (reached via uniqueKeyPath)
	///
	/// Process the wrappers returning a tuple of:
	/// * a replacement for wrappers with updates optionally pplied and wrappers removed that didn't have a matching newValue
	/// * the subset of newValues that need to have `Wrapper`s created and added to updated
	/// * the subset of objects removed from wrappers
	///
	/// - Parameters:
	///   - wrappers: A set of Wrapper objects
	///   - newValues: An array of wrapped objects to update the wrappers set with
	///   - valueKeyPath: The keyPath of the Wrapper to a property of type Value
	///   - uniqueKeyPath: A unique property of Value to match wrappers to newValues
	///   - performUpdate: If true, actually update the wrapper's valueKeyPath with the newValue
	/// - Returns: A tuple of: Values that should be added, wrappers that should be removed, and wrappers that should remain (with updates applied)
	func filterForUpdate<Value: Equatable, T: Equatable>(
		newValues: [Value],
		valueKeyPath: ReferenceWritableKeyPath<Element, Value>,
		uniqueKeyPath: KeyPath<Value, T>,
		performUpdate: Bool
		) -> (updated: Set<Element>, added: [Value], removed: Set<Element>)
	{
		var added = [Value]()
		var keeping = Set<Element>()
		// make a copy of wrappers we can remove objects from as they are matched
		var remaining = self
		
		newValues.forEach { aValue in
			let fullKeyPath = valueKeyPath.appending(path: uniqueKeyPath)
			if let oldValue = first(where: {
				let v1 = $0[keyPath: fullKeyPath]
				let v2 = aValue[keyPath: uniqueKeyPath]
				return v1 == v2
			})
			{
				if performUpdate {
					oldValue[keyPath: valueKeyPath] = aValue
				}
				keeping.insert(oldValue)
				remaining.remove(oldValue)
			} else {
				added.append(aValue)
			}
		}
		return (updated: keeping, added: added, removed: remaining)
	}
}
