//
//  Int+Commas.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import Foundation

extension Int {
	func withCommas() -> String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		return numberFormatter.string(from: NSNumber(value:self))!
	}
}
