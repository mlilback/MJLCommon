//
//  Collection+MJL.swift
//  Rc2Common
//
//  Created by Mark Lilback on 11/19/20.
//  Copyright © 2020 Rc2. All rights reserved.
//

import Foundation

extension Collection {
	/// Same as the normal subscript operator, but returns nil instead of throwing an error
	public subscript(safe index: Index) -> Element? {
		return index >= startIndex && index < endIndex ? self[index] : nil
	}
}
