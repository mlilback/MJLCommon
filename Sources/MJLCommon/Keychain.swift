//
//  Keychain.swift
//
//  Copyright ©2016 Mark Lilback. This file is licensed under the ISC license.
//

import Foundation
import Security

private let SecClass: String = kSecClass as String
private let SecValueData: String = kSecValueData as String

/// simple access to the keychain. All items are stored/retrieved as kSecClassGenericPassword
public class Keychain {
	let service: String
	let secClass: String
	
	/// Creates a Keychain object
	/// - Parameter service: The name the item will be stored under. This should generally be your bundle identifier
	public init(service: String, secClass: CFString = kSecClassGenericPassword) {
		guard secClass == kSecClassInternetPassword || secClass == kSecClassGenericPassword
		else { fatalError("unsupported secClass") }
		self.service = service
		self.secClass = secClass as String
	}
	
	/// Gets data from the keychain
	/// - Parameter key: the key the data was stored under
	/// - Returns: the value as a Data object. Returns nil if not found or there is an error
	public func getData(key: String) -> Data? {
		let query = setupQuery(key)
		var dataRef: AnyObject?
		let status = withUnsafeMutablePointer(to: &dataRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
		guard status == noErr && dataRef != nil else { return nil }
		return dataRef as? Data
	}
	
	/// Gets string from the keychain
	/// - Parameter key: the key the data was stored under
	/// - Returns: the value as a String. Returns nil if not found or there is an error
	public func getString(key: String) -> String? {
		guard let data = getData(key: key) else { return nil }
		return String(data: data, encoding: .utf8)
	}
	
	/// Removes any
	/// - Parameter key: The key the item is stored under
	/// - Returns: true/false depending if successful
	/// - Throws: NSError of domain NSOSStatusErrorDomain if any Kechain API call results in an error
	@discardableResult public func removeKey(key: String) throws -> Bool {
		let query = setupQuery(key)
		let status = SecItemDelete(query as CFDictionary)
		if status == noErr { return true }
		throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
	}
	
	/// Sets a value in the keychain
	/// - Parameters:
	///   - key: the key to store the data under
	///   - value: the string to store
	/// - Throws: NSError of domain NSOSStatusErrorDomain if any Kechain API call results in an error
	public func setString(key: String, value: String?) throws {
		try setData(key: key, value: value?.data(using: .utf8))
	}
	
	/// Sets a value in the keychain
	/// - Parameters:
	///   - key: the key to store the data under
	///   - value: the data to store
	/// - Throws: NSError of domain NSOSStatusErrorDomain if any Kechain API call results in an error
	public func setData(key: String, value: Data?) throws {
		guard let valueToStore = value else {
			try removeKey(key: key)
			return
		}
		var query = setupQuery(key)
		var status: OSStatus = noErr
		if let existing = getData(key: key) {
			guard existing != value else {
				return
			}
			let values: [String:AnyObject] = [SecValueData: value as AnyObject]
			status = SecItemUpdate(query as CFDictionary, values as CFDictionary)
		} else {
			query[SecValueData] =  valueToStore as AnyObject?
			status = SecItemAdd(query as CFDictionary, nil)
		}
		if status != errSecSuccess {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
		}
	}

	private func setupQuery(_ key: String) -> [String:AnyObject] {
		var query: [String: AnyObject] = [SecClass: secClass as AnyObject]
		query[kSecAttrService as String] = service as AnyObject?
		query[kSecAttrAccount as String] = key as AnyObject?
		query[kSecReturnData as String] = kCFBooleanTrue
		return query
	}
}
