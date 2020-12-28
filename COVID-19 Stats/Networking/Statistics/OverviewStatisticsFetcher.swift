//
//  OverviewStatisticsFetcher.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation
import Combine

class OverviewStatisticsFetcher {
	
	private let session: URLSession
	
	// MARK: - Init
	init(session: URLSession = .shared) {
		self.session = session
	}
	
}

// MARK: - OverviewStatisticsFetchable
extension OverviewStatisticsFetcher: OverviewStatisticsFetchable {
	
	func fetchOverviewStatistics() -> AnyPublisher<StatisticsResponse, Error> {
		
		var components = URLComponents()
		components.scheme = "https"
		components.host = "api.coronavirus.data.gov.uk"
		components.path = "/v1/data"
		components.queryItems = [
			URLQueryItem(name: "filters", value: "areaType=overview"),
			URLQueryItem(name: "structure", value: """
			{"date":"date","areaName":"areaName","areaCode":"areaCode","newCasesByPublishDate":"newCasesByPublishDate","cumCasesByPublishDate":"cumCasesByPublishDate","newDeaths28DaysByDeathDate":"newDeaths28DaysByDeathDate","cumDeaths28DaysByDeathDate":"cumDeaths28DaysByDeathDate","covidOccupiedMVBeds":"covidOccupiedMVBeds","hospitalCases":"hospitalCases"}
			""")
		]
		
		let request = URLRequest(url: components.url!)
		
		return session.dataTaskPublisher(for: request)
			
			.tryMap({ (data, response) -> Data in
				
				#if DEBUG
				print("--- DEBUG NETWORK LOGS ---")
				print("--- URL: \(response.url?.absoluteString ?? "unknown")")
				#endif
				
				if let response = response as? HTTPURLResponse,
					(200..<300).contains(response.statusCode) == false {
					
					#if DEBUG
					print("--- Error - HTTP status code: \(response.statusCode)")
					#endif
					
					throw HTTPError(integerLiteral: response.statusCode)
					
				} else if let errorResponse = try? JSONDecoder().decode(StatisticsErrorResponse.self, from: data) {
					
					#if DEBUG
					print("--- Error - \(errorResponse)")
					#endif
					
					throw errorResponse
					
				}
				
				#if DEBUG
				print("--- Response body: " + (String(data: data, encoding: .utf8) ?? "unknown"))
				#endif

				return data
			})
			.decode(type: StatisticsResponse.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
		
	}
	
}

protocol OverviewStatisticsFetchable {
	func fetchOverviewStatistics() -> AnyPublisher<StatisticsResponse, Error>
}