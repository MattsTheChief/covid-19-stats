//
//  Array+Trailing.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation

extension Array {
	mutating func removeTrailingEmptyEntries<T: BinaryInteger>(for keyPath: KeyPath<Element, T>) {
		guard let lastNonEmptyIndex = lastIndex(where: { $0[keyPath: keyPath] > 0 }) else {
			return
		}
		removeLast(count - lastNonEmptyIndex - 1)
	}
}
