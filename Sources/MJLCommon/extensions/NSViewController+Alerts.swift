//
//  NSViewController+Alerts.swift
//
//  Copyright ©2017 Mark Lilback. This file is licensed under the ISC license.
//

import Cocoa
// TODO: use canImport for this when running on swift 4.1
import SwiftyUserDefaults

public extension NSViewController {
	/// Displays an alert sheet to confirm an action. If the defaults value for the suppressionKey is true, the handler is immediately called with true.
	///
	/// - Parameters:
	///   - message: The message to display
	///   - infoText: The informative text to display
	///   - buttonTitle: The title for the rightmost/action button
	///   - defaultToCancel: true if the cancel button should be the default button. defaults to false
	///   - suppressionKey: Optional UserDefaults key to set to true if user selects to suppress future alerts. If nil, suppression checkbox is not displayed. Defaults to nil. If the key value is true, no sheet is shown and the handler is immediately called with a value of true.
	///   - handler: called after the user has selected an action
	///   - confirmed: true if the user selected the action button
	func confirmAction(message: String, infoText: String, buttonTitle: String, cancelTitle: String = NSLocalizedString("Cancel", comment: ""), defaultToCancel: Bool = false, suppressionKey: String? = nil, handler: @escaping (_ confirmed: Bool) -> Void)
	{
		if let key = suppressionKey, UserDefaults.standard.bool(forKey: key) {
			handler(true)
			return
		}
		precondition(view.window != nil,"can't call without being in a window")
		let alert = NSAlert()
		alert.showsSuppressionButton = suppressionKey != nil
		alert.messageText = message
		alert.informativeText = infoText
		alert.addButton(withTitle: buttonTitle)
		alert.addButton(withTitle: cancelTitle)
		if defaultToCancel {
			alert.buttons[0].keyEquivalent = ""
			alert.buttons[1].keyEquivalent = "\r"
		}
		alert.beginSheetModal(for: self.view.window!, completionHandler: { [weak alert] response in
			if let key = suppressionKey, alert?.suppressionButton?.state ?? .off == .on {
				UserDefaults.standard.set(true, forKey: key)
			}
			handler(response == .alertFirstButtonReturn)
		})
	}

	/// Displays an alert sheet to confirm an action. This versions takes a supression key in the format used by SwiftyUserDefaults. If such a value is not supplied or is a string, another version of this function is called. If the defaults value for the suppressionKey is true, the handler is immediately called with true.
	///
	/// - Parameters:
	///   - message: The message to display
	///   - infoText: The informative text to display
	///   - buttonTitle: The title for the rightmost/action button
	///   - defaultToCancel: true if the cancel button should be the default button. defaults to false
	///   - suppressionKey: Optional UserDefaults key to set to true if user selects to suppress future alerts
	///   - handler: called after the user has selected an action
	///   - confirmed: true if the user selected the action button
	func confirmAction(message: String, infoText: String, buttonTitle: String, cancelTitle: String = NSLocalizedString("Cancel", comment: ""), defaultToCancel: Bool = false, suppressionKey: DefaultsKey<Bool>, handler: @escaping (_ confirmed: Bool) -> Void)
	{
		guard !UserDefaults.standard[suppressionKey] else {
			handler(true)
			return
		}
		let alert = NSAlert()
		alert.showsSuppressionButton = true
		alert.messageText = message
		alert.informativeText = infoText
		alert.addButton(withTitle: buttonTitle)
		alert.addButton(withTitle: cancelTitle)
		if defaultToCancel {
			alert.buttons[0].keyEquivalent = ""
			alert.buttons[1].keyEquivalent = "\r"
		}
		alert.beginSheetModal(for: self.view.window!, completionHandler: { [weak alert] response in
			if alert?.suppressionButton?.state ?? .off == .on {
				UserDefaults.standard[suppressionKey] = true
			}
			handler(response == .alertFirstButtonReturn)
		})
	}
}

