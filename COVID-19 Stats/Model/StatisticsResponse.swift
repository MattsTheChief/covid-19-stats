//
//  StatisticsResponse.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation

// MARK: - StatisticsResponse
struct StatisticsResponse: Codable {
	let length: Int
	let maxPageLimit: Int
	let data: [StatisticsData]
	let pagination: Pagination
}

// MARK: - StatisticsData
struct StatisticsData: Codable {
	let date: Date
	let areaName: String
	let areaCode: String
	let newCasesByPublishDate: Int?
	let cumCasesByPublishDate: Int?
	let newDeaths28DaysByPublishDate: Int?
	let cumDeaths28DaysByPublishDate: Int?
	let covidOccupiedMVBeds: Int?
	let hospitalCases: Int?
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		areaName = try container.decode(String.self, forKey: .areaName)
		areaCode = try container.decode(String.self, forKey: .areaCode)
		newCasesByPublishDate = try? container.decode(Int.self, forKey: .newCasesByPublishDate)
		cumCasesByPublishDate = try? container.decode(Int.self, forKey: .cumCasesByPublishDate)
		newDeaths28DaysByPublishDate = try? container.decode(Int.self, forKey: .newDeaths28DaysByPublishDate)
		cumDeaths28DaysByPublishDate = try? container.decode(Int.self, forKey: .cumDeaths28DaysByPublishDate)
		covidOccupiedMVBeds = try? container.decode(Int.self, forKey: .covidOccupiedMVBeds)
		hospitalCases = try? container.decode(Int.self, forKey: .hospitalCases)

		let dateString = try container.decode(String.self, forKey: .date)
		let formatter = DateFormatter.yyyyMMdd
		if let date = formatter.date(from: dateString) {
			self.date = date
		} else {
			throw DecodingError.dataCorruptedError(forKey: .date,
				  in: container,
				  debugDescription: "Date string does not match format expected by formatter.")
		}
	  }
}


// MARK: - Pagination
struct Pagination: Codable {
	let current: String
	let next, previous: String?
	let first, last: String
}
