//
//  ExpiringCache.swift
//
//  Copyright ©2017 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

/// a psuedo dicionary that can remove items after a certain time interval has passed
/// the owner must call expire() to remove expired entries
public struct ExpiringCache<Key: Hashable, Value>: Collection {
	public typealias Element = (key: Key, value: Value)
	public typealias Iterator = DictionaryIterator<Key, Value>
	public typealias Index = DictionaryIndex<Key, Value>
	
	private var contents = [Key: Value]()
	private var times = [Key: TimeInterval]()
	
	public var startIndex: Index { return contents.startIndex }
	public var endIndex: Dictionary<Key, Value>.Index { return contents.endIndex }
	
	public let entryDuration: TimeInterval
	
	/// create an expiring cache
	///
	/// - Parameter duration: the lifetime of an entry in the cache
	public init(duration: TimeInterval) {
		entryDuration = duration
	}
	
	public subscript (position: Index) -> Iterator.Element {
		return contents[position]
	}
	
	public subscript (key: Key) -> Value? {
		get { return contents[key] }
		set {
			contents[key] = newValue
			guard newValue != nil else { times.removeValue(forKey: key); return }
			times[key] = Date.timeIntervalSinceReferenceDate
		}
	}
	
	/// Removes all items from the cache
	public mutating func removeAll() {
		contents.removeAll()
		times.removeAll()
	}
	
	/// removes all expired items from the cache
	public mutating func expire() {
		let targetTime = Date.timeIntervalSinceReferenceDate - entryDuration
		times.keys.forEach {
			guard let keyTime = times[$0] else { return }
			if keyTime > targetTime {
				contents.removeValue(forKey: $0)
				times.removeValue(forKey: $0)
			}
		}
	}
	
	/// remove the value stored for key from the cache
	public mutating func removeValue(forKey key: Key) {
		contents.removeValue(forKey: key)
		times.removeValue(forKey: key)
	}
	
	public func index(after i: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Index {
		return contents.index(after: i)
	}
	
	public func makeIterator() -> DictionaryIterator<Key, Value> {
		return contents.makeIterator()
	}
}
