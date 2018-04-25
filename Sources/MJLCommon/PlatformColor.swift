//
//  PlatformColor.swift
//
//  Copyright ©2016 Mark Lilback. This file is licensed under the ISC license.
//

#if os(OSX)
	import AppKit
	public typealias PlatformColor = NSColor
	public typealias PlatformImage = NSImage
	public typealias PlatformFont = NSFont
#else
	import UIKit
	public typealias PlatformColor = UIColor
	public typealias PlatformImage = UIImage
	public typealias PlatformFont = UIFont
#endif

extension CharacterSet {
	/// valid characters in a hexadecimal string, including both upper- and lowercase
	static var hexadecimal: CharacterSet = { CharacterSet(charactersIn: "0123456789AaBbCcDdEeFf") }()
}

public extension PlatformColor {
	// scans a two character two characters from a string into hex, then returns value converted to a CGFloat
	private static func scanFloatFromHex(string: String, startOffset: Int) -> CGFloat {
		guard string.count >= startOffset + 1 else { fatalError("invalid string offset") }
		let endOffset = startOffset + 2
		let range = string.index(string.startIndex, offsetBy: startOffset) ..< string.index(string.startIndex, offsetBy: endOffset)
		var hexInt: CUnsignedInt = 0
		Scanner(string: String(string[range])).scanHexInt32(&hexInt)
		return CGFloat(CGFloat(hexInt) / 255.0)
	}
	
	//parses a hexstring into 4 float values. throws exception if not valid hex string
	private static func parse(hexString: String) throws -> (CGFloat, CGFloat, CGFloat, CGFloat) {
		var hcode = hexString
		if hcode.hasPrefix("#") {
			hcode = String(hcode[hcode.index(hcode.startIndex, offsetBy: 1)...])
		}
		guard hcode.count == 6 || hcode.count == 8,
			hcode.trimmingCharacters(in: .hexadecimal) == ""
			else { throw GenericError("invalid hex string") }
		
		var alpha: CGFloat = 1.0
		if hcode.count == 8 { alpha = scanFloatFromHex(string: hexString, startOffset: 6) }
		return (scanFloatFromHex(string: hexString, startOffset: 0), scanFloatFromHex(string: hexString, startOffset: 2), scanFloatFromHex(string: hexString, startOffset: 4), alpha)
	}
	
	/// initialize a color from a hex string
	///
	/// - Parameters:
	///   - hexString: A hex string in RRGGBB or RRGGBBAA format, with an optional # at the start
	public convenience init?(hexString: String) {
		do {
			let vals = try PlatformColor.parse(hexString: hexString)
			self.init(red: vals.0, green: vals.1, blue: vals.2, alpha: vals.3)
		} catch {
			return nil
		}
	}
	
	/// the color as a hex string, without a leading # character
	public var hexString: String {
		let red = UInt8(redComponent * 255.0)
		let green = UInt8(greenComponent * 255.0)
		let blue = UInt8(blueComponent * 255.0)
		var baseStr = String(format: "%0.2X%0.2X%0.2X", red, green, blue)
		let alpha = UInt8(alphaComponent * 255.0)
		if alpha < 255 {
			baseStr += String(format: "%0.2X", alpha)
		}
		return baseStr
	}
	
	/// Compares two colors by RGBA components
	///
	/// - Parameter other: another color to compare self to
	/// - Parameter accuracy: how far off the component values can be (since float equality is not always exact)
	/// - Returns: true if equal to other color within accuracy
	public func equals(_ other: PlatformColor, accuracy: CGFloat = 0.01) -> Bool {
		let rdist = abs(self.redComponent - other.redComponent)._rounded(toPlaces: 4)
		let gdist = abs(self.greenComponent - other.greenComponent)._rounded(toPlaces: 4)
		let bdist = abs(self.blueComponent - other.blueComponent)._rounded(toPlaces: 4)
		let adist = abs(self.alphaComponent - other.alphaComponent)._rounded(toPlaces: 4)
		return rdist <= accuracy && gdist <= accuracy && bdist <= accuracy && adist <= accuracy
	}
}

fileprivate extension BinaryFloatingPoint {
	/// rounds a float to a specified number of places. Named with underscore to not conflict if swift stdlib adds a similarily named function
	// see [StackExchange](https://codereview.stackexchange.com/a/142850/158119)
	func _rounded(toPlaces places: Int) -> Self {
		guard places >= 0 else { return self }
		let divisor = Self((0..<places).reduce(1.0) { (accum, _) in 10.0 * accum })
		return (self * divisor).rounded() / divisor
	}
}
