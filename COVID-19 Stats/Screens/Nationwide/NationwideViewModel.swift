//
//  NationwideViewModel.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation
import Combine

class NationwideViewModel: ObservableObject {
	
	@Published var data: [StatisticsData] = []
	
	@Published var dailyCases: [DailyCaseEntry] = []
	@Published var dailyDeaths: [DailyDeathEntry] = []
	@Published var hospitalCases: [HospitalCaseEntry] = []
	
	@Published var dailyCasesLegend: String = "Loading..."
	@Published var dailyDeathsLegend: String = "Loading..."
	@Published var hospitalCasesLegend: String = "Loading..."
	
	
	private let overviewStatisticsFetcher: OverviewStatisticsFetchable
	private var disposables = Set<AnyCancellable>()
	
	// MARK: - Init
	init(overviewStatisticsFetcher: OverviewStatisticsFetchable = OverviewStatisticsFetcher()) {
		self.overviewStatisticsFetcher = overviewStatisticsFetcher
		fetchOverviewStatistics()
	}
	
	// MARK: - Fetch
	func fetchOverviewStatistics() {
		overviewStatisticsFetcher.fetchOverviewStatistics()
			.map { response in
				response.data
			}
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { [weak self] value in
					guard let weakSelf = self else {
						return
					}
					switch value {
					case .failure:
						weakSelf.data = []
					case .finished:
						break
					}
				},
				receiveValue: { [weak self] data in
					guard let weakSelf = self else {
						return
					}
					
					var dailyCases = data.reversed().map { DailyCaseEntry(numberOfCases: $0.newCasesByPublishDate ?? 0,
																		  date: $0.date) }
					dailyCases.removeTrailingEmptyEntries(for: \.numberOfCases)
					weakSelf.dailyCases = dailyCases
					
					var dailyDeaths = data.reversed().map { DailyDeathEntry(numberOfDeaths: $0.newDeaths28DaysByDeathDate ?? 0,
																			date: $0.date) }
					dailyDeaths.removeTrailingEmptyEntries(for: \.numberOfDeaths)
					weakSelf.dailyDeaths = dailyDeaths
					
					var hospitalCases = data.reversed().map { HospitalCaseEntry(numberOfHospitalCases: $0.hospitalCases ?? 0,
																					date: $0.date) }
					hospitalCases.removeTrailingEmptyEntries(for: \.numberOfHospitalCases)
					weakSelf.hospitalCases = hospitalCases
					
					weakSelf.updateLegends()
				})
			.store(in: &disposables)
	}
	
	private func updateLegends() {
		dailyCasesLegend = legend(startDate: dailyCases.first?.date,
								  lastDate: dailyCases.last?.date)
		dailyDeathsLegend = legend(startDate: dailyDeaths.first?.date,
								   lastDate: dailyDeaths.last?.date)
		hospitalCasesLegend = legend(startDate: hospitalCases.first?.date,
										lastDate: hospitalCases.last?.date)
	}
	
	private func legend(startDate: Date?, lastDate: Date?) -> String {
		guard let startDate = startDate,
			  let lastDate = lastDate else {
			return "Loading..."
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy"
		let firstDateString = dateFormatter.string(from: startDate)
		let lastDateString = dateFormatter.string(from: lastDate)
		
		return firstDateString + " - " + lastDateString
	}
	
}

// MARK: - Models
struct DailyCaseEntry {
	let numberOfCases: Int
	let date: Date
}

struct DailyDeathEntry {
	let numberOfDeaths: Int
	let date: Date
}

struct HospitalCaseEntry {
	let numberOfHospitalCases: Int
	let date: Date
}
