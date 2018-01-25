//
//  PlatformColorTests.swift
//
//  Created by Mark Lilback on 1/15/18.
//

import XCTest
import Cocoa
@testable import MJLCommon

// Value type for testing
struct Person: Equatable, CustomStringConvertible {
	let id: Int
	let name: String
	let age: Int
	
	var description: String { return "Person \(name)" }
	
	static func ==(lhs: Person, rhs: Person) -> Bool {
		return lhs.id == rhs.id && lhs.name == rhs.name && lhs.age == rhs.age
	}
}

// Wrapper type for testing
class PersonWrapper: Hashable, CustomStringConvertible {
	var person: Person
	
	init(_ aPerson: Person) {
		self.person = aPerson
	}
	
	var description: String { return "wrapper \(person.name)" }
	var hashValue: Int { return ObjectIdentifier(self).hashValue }
	
	static func ==(lhs: PersonWrapper, rhs: PersonWrapper) -> Bool {
		return lhs.person == rhs.person
	}
}

class SetUpdateTests: XCTestCase {
	func testUpdate() {
		let p1 = Person(id: 1, name: "Mark", age: 45)
		let p2 = Person(id: 2, name: "Kenny", age: 43)
		let p3 = Person(id: 3, name: "Brandon", age: 5)
		let p4 = Person(id: 4, name: "Brynlee", age: 2)
		let updatedP2 = Person(id: 2, name: "Kenneth", age: 43)
		
		let revised = [updatedP2, p3, p4]
		let wrappedPersons = [p1, p2, p3, p4, updatedP2].map { PersonWrapper($0) }
		let wrappers = Set<PersonWrapper>(wrappedPersons[0..<3])
		
		let (updated, added, removed) = wrappers.update(
			newValues: revised,
			valueKeyPath: \PersonWrapper.person,
			uniqueKeyPath: \Person.id)

		XCTAssertEqual(updated.count, 2)
		XCTAssertTrue(updated.contains(wrappedPersons[2]))
		XCTAssertTrue(updated.contains(wrappedPersons[1]))
		XCTAssertEqual(updatedP2.name, updated.first(where: { $0.person.id == 2} )?.person.name)
	
		XCTAssertEqual(added.count, 1)
		XCTAssertEqual(added[0], p4)

		XCTAssertEqual(removed.count, 1)
		XCTAssertTrue(removed.contains(wrappedPersons[0]))
	}
}
