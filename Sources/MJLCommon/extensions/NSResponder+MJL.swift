//
//  NSResponder+MJL.swift
//  
//
//  Created by Mark Lilback on 11/11/19.
//

import Cocoa

extension NSResponder {
	static func inspectResponderChain() {
		var responder: NSResponder?
		guard let window = NSApp.mainWindow else { return }
		responder = window.firstResponder
		while responder != nil {
			print("\t\(responder!.debugDescription)")
			responder = responder!.nextResponder
		}
	}
}
