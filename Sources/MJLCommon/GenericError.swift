//
//  GenericError.swift
//
//  Copyright ©2018 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation

public struct GenericError: Error, LocalizedError, CustomStringConvertible {
	let message: String
	public var errorDescription: String? { return message }
	public var description: String { return message }
	
	public init(_ message: String) {
		self.message = message
	}
}
