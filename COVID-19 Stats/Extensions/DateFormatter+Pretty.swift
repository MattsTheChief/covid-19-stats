//
//  DateFormatter+Pretty.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation

extension DateFormatter {
	
	static let yyyyMMdd: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "uk")
		return formatter
	}()
	
	static let dMyy: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "d/M/yy"
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.locale = Locale(identifier: "uk")
		return formatter
	}()
	
}
