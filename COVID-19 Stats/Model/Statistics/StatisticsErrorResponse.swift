//
//  StatisticsErrorResponse.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation

// MARK: - StatisticsErrorResponse
struct StatisticsErrorResponse: Error, Codable {
	let response: String
	let statusCode: Int
	let status: String

	enum CodingKeys: String, CodingKey {
		case response
		case statusCode = "status_code"
		case status
	}
}
