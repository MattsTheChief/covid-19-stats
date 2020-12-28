//
//  NationwideViewModel.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation
import Combine
import SwiftUI

class NationwideViewModel: ObservableObject {
	
	private var rawData: [StatisticsData] = []
	
	@Published var dailyCases: [DailyCaseEntry] = []
	@Published var dailyDeaths: [DailyDeathEntry] = []
	@Published var hospitalCases: [HospitalCaseEntry] = []
	
	@Published var dailyCasesLegend: String = "Loading..."
	@Published var dailyDeathsLegend: String = "Loading..."
	@Published var hospitalCasesLegend: String = "Loading..."
	
	@Published var selectedDateRange = 0 {
		didSet {
			guard let dateRangeOption = DateRangeOption(rawValue: selectedDateRange) else {
				fatalError("Unsupport date range option selected")
			}
			updateForDateRange(dateRangeOption)
		}
	}
	var dateRangeOptions = ["All time", "Last 3 months", "Last 28 days"]
	
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
						weakSelf.rawData = []
					case .finished:
						break
					}
				},
				receiveValue: { [weak self] data in
					guard let weakSelf = self else {
						return
					}
					
					weakSelf.rawData = data
					
					weakSelf.calculateDailyCases()
					weakSelf.calculateDailyDeaths()
					weakSelf.calculateHospitalCases()
					
					weakSelf.updateLegends()
				})
			.store(in: &disposables)
	}
	
	private func calculateDailyCases(dateRange: DateRangeOption  = .allTime) {
		var dailyCases = rawData.reversed().map { DailyCaseEntry(numberOfCases: $0.newCasesByPublishDate ?? 0,
																 date: $0.date) }
		dailyCases.removeTrailingEmptyEntries(for: \.numberOfCases)
		dailyCases.removeLeadingEmptyEntries(for: \.numberOfCases)
		
		let cutOffDate = calculateCutOffDate(dateRange: dateRange)
		let dateRange = cutOffDate...Date()
		dailyCases = dailyCases.filter({ dateRange.contains($0.date) })
		
		self.dailyCases = dailyCases
	}
	
	private func calculateDailyDeaths(dateRange: DateRangeOption  = .allTime) {
		var dailyDeaths = rawData.reversed().map { DailyDeathEntry(numberOfDeaths: $0.newDeaths28DaysByDeathDate ?? 0,
																   date: $0.date) }
		dailyDeaths.removeTrailingEmptyEntries(for: \.numberOfDeaths)
		dailyDeaths.removeLeadingEmptyEntries(for: \.numberOfDeaths)
		
		let cutOffDate = calculateCutOffDate(dateRange: dateRange)
		let dateRange = cutOffDate...Date()
		dailyDeaths = dailyDeaths.filter({ dateRange.contains($0.date) })
		
		self.dailyDeaths = dailyDeaths
	}
	
	private func calculateHospitalCases(dateRange: DateRangeOption  = .allTime) {
		var hospitalCases = rawData.reversed().map { HospitalCaseEntry(numberOfHospitalCases: $0.hospitalCases ?? 0,
																	   date: $0.date) }
		hospitalCases.removeTrailingEmptyEntries(for: \.numberOfHospitalCases)
		hospitalCases.removeLeadingEmptyEntries(for: \.numberOfHospitalCases)
		
		let cutOffDate = calculateCutOffDate(dateRange: dateRange)
		let dateRange = cutOffDate...Date()
		hospitalCases = hospitalCases.filter({ dateRange.contains($0.date) })
		
		self.hospitalCases = hospitalCases
	}
	
	private func calculateCutOffDate(dateRange: DateRangeOption) -> Date {
		var cutOffDate = Date().addingTimeInterval(-Double.infinity)
		
		switch dateRange {
		case .last28Days:
			cutOffDate = Date().addingTimeInterval(-2419200)
		case .last3Months:
			cutOffDate = Date().addingTimeInterval(-7890000)
		case .allTime:
			break
		}
		
		return cutOffDate
	}
	
	// MARK: - Update
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
	
	private func updateForDateRange(_ dateRange: DateRangeOption) {
		calculateDailyCases(dateRange: dateRange)
		calculateDailyDeaths(dateRange: dateRange)
		calculateHospitalCases(dateRange: dateRange)
		updateLegends()
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

enum DateRangeOption: Int {
	case allTime = 0
	case last3Months = 1
	case last28Days = 2
}
