//
//  NSViewController+Alerts.swift
//
//  Copyright ©2017 Mark Lilback. This file is licensed under the ISC license.
//

import Cocoa

public extension NSFont {
	/// returns self modified with the specified traits. If there is no such font avaiable, returns self
	func with(traits: NSFontDescriptor.SymbolicTraits) -> NSFont {
		let descriptor = self.fontDescriptor.withSymbolicTraits(traits)
		return NSFont(descriptor: descriptor, size: self.pointSize) ?? self
	}
	
	/// an italic version of self, or self if there isn't an italic version
	var italic: NSFont {
		return with(traits: .italic)
	}
	
	/// a bold version of self, or self if there isn't a bold version
	var bold: NSFont {
		return with(traits: .bold)
	}
	
	/// a boldItalic version of self, or self if there isn't a BoldItalic variant
	var boldItalic: NSFont {
		return with(traits: [.bold, .italic])
	}
}
