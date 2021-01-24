//
//  PostcodeValidator.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import Foundation

struct PostcodeValidator {
	static let pattern = "^([A-Za-z][A-Ha-hJ-Yj-y]?[0-9][A-Za-z0-9]? ?[0-9][A-Za-z]{2}|[Gg][Ii][Rr] ?0[Aa]{2})$"
	static func validate(input: String) -> Bool {
		return Regex(pattern).test(input: input)
	}
}

private class Regex {
	let internalExpression: NSRegularExpression
	let pattern: String
  
	init(_ pattern: String) {
		self.pattern = pattern
		self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
	}
  
	func test(input: String) -> Bool {
		let matches = self.internalExpression.matches(in: input, options: NSRegularExpression.MatchingOptions.anchored, range: NSMakeRange(0, input.count))
		return matches.count > 0
	}
}

