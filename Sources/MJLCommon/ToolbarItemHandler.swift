//
//  ToolbarItemHandler.swift
//
//  Copyright ©2016 Mark Lilback. This file is licensed under the ISC license.
//

// This file should only be included in macOS targets
#if os(macOS)
import Cocoa
//import ClientCore
#endif

@available(macOS 10.12, *)
protocol ToolbarItemHandler : class {
	///called by a top level controller for each toolbar item no one has claimed
	func handlesToolbarItem(_ item: NSToolbarItem) -> Bool
	///should be called in viewDidAppear for lazy loaded views to hookup to toolbar items
	func hookupToToolbarItems(_ handler: ToolbarItemHandler, window: NSWindow)
}

@available(macOS 10.12, *)
protocol ToolbarDelegatingOwner : class {
	//should be called when views have loaded
	func assignHandlers(_ rootController: NSViewController, items: [NSToolbarItem])
	///called by hookupToolbarItems so a lazy-loaded controller can hook up items it supports
	func assignUnclaimedToolbarItems(_ toolbar: NSToolbar, handler: ToolbarItemHandler)
}

@available(macOS 10.12, *)
extension ToolbarItemHandler {
	func hookupToToolbarItems(_ handler: ToolbarItemHandler, window: NSWindow) {
		//find owner
		if let owner: ToolbarDelegatingOwner = _firstChildViewController(window.contentViewController!) {
			owner.assignUnclaimedToolbarItems(window.toolbar!, handler: handler)
		}
	}
}

@available(macOS 10.12, *)
extension ToolbarDelegatingOwner {
	func assignUnclaimedToolbarItems(_ toolbar: NSToolbar, handler: ToolbarItemHandler) {
		for item in toolbar.items where item.action == nil {
			_ = handler.handlesToolbarItem(item)
		}
	}
	
	func assignHandlers(_ rootController: NSViewController, items: [NSToolbarItem]) {
		//find every ToolbarItemHandler in rootController
		let handlers = recursiveFlatMap(rootController, children: { $0.children }, transform: { $0 as? ToolbarItemHandler })
		//loop through toolbar items looking for the first handler that handles the item
		for anItem in items {
			for aHandler in handlers {
				if aHandler.handlesToolbarItem(anItem) { break; }
			}
		}
	}
}

//this subclass allows a closure to be injected for validation
@available(macOS 10.12, *)
class ValidatingToolbarItem: NSToolbarItem {
	typealias ToolbarValidationHandler = (ValidatingToolbarItem) -> Void
	var validationHandler: ToolbarValidationHandler?
	
	override func validate() {
		self.validationHandler?(self)
	}
}

@available(macOS 10.12, *)
fileprivate func _firstChildViewController<T>(_ rootController: NSViewController) -> T?
{
	return firstRecursiveDescendent(rootController,
									children: { return $0.children },
									filter: { return $0 is T }) as? T
}

/// Use the following code in a NSWindowController subclass that is the toolbar's delegate

/// Need to schedule setting up toolbar handlers, but don't want to do it more than once
//	fileprivate var toolbarSetupScheduled = false


	//When the first toolbar item is loaded, queue a closure to call assignHandlers from the ToolbarDelegatingOwner protocol(default implementation) that assigns each toolbar item to the appropriate ToolbarItemHandler (normally a view controller)
//	func toolbarWillAddItem(_ notification: Notification) {
//		//schedule assigning handlers after toolbar items are loaded
//		if !toolbarSetupScheduled {
//			DispatchQueue.main.async {
//				self.assignHandlers(self.contentViewController!, items: (self.window?.toolbar?.items)!)
//			}
//			toolbarSetupScheduled = true
//		}
//		let item: NSToolbarItem = ((notification as NSNotification).userInfo!["item"] as? NSToolbarItem)!
//		if item.itemIdentifier == "status",
//			let sview = item.view as? AppStatusView
//		{
//			statusView = sview
//		}
//	}
