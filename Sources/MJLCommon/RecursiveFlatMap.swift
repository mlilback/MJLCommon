//
//  RecursiveFlatMap.swift
//
//  Copyright ©2016 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

///returns array of all recursive children of root that pass the test in transform
//
//ideally transform and children weould be @noescape, but you can't call another
// noescape function, even though it should be fine with the same functiuon


/// Find recursive child objects that pass a test transformed into another type
///
/// - Parameters:
///   - root: the root object to search
///   - children: a closure that returns the children of root
///   - transform: a closure that transforms type T into TResult
/// - Returns: an array of TResult objects
public func recursiveFlatMap<T, TResult>(_ root: T, children: (T) -> [T], transform: (T) -> TResult?) -> [TResult]
{
	var result = [TResult]()
	if let value = transform(root) {
		result.append(value)
	}
	result += children(root).flatMap( { recursiveFlatMap($0, children: children, transform: transform) })
	return result
}

/// Performs a breadth-first search for the first decendent passing a test
///
/// - Parameters:
///   - root: the parent object whose children should be searched
///   - children: A closure that returns the children of root
///   - filter: a closure to determine if a child is the droid you're looking for
/// - Returns: the first matching child, or nil
public func  firstRecursiveDescendent<T>(_ root: T, children: (T) -> [T], filter: (T) -> Bool) -> T?
{
	if filter(root) { return root }
	for aChild in children(root) {
		if filter(aChild) { return aChild }
	}
	for aChild in children(root) {
		if let childValue = firstRecursiveDescendent(aChild, children: children, filter: filter) {
			return childValue
		}
	}
	return nil
}
