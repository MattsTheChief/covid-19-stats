//
//  StatisticsViewModel.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
	
	private var rawData: [StatisticsData] = []
	
	@Published var dailyCases: [DailyCaseEntry] = []
	@Published var dailyDeaths: [DailyDeathEntry] = []
	@Published var hospitalCases: [HospitalCaseEntry] = []
	
	var todaysCases: Int? {
		didSet {
			todaysCasesPretty = todaysCases != nil ? "\(todaysCases!.withCommas())" : "-"
		}
	}
	
	var todaysDeaths: Int? {
		didSet {
			todaysDeathsPretty = todaysDeaths != nil ? "\(todaysDeaths!.withCommas())" : "-"
		}
	}
	
	var todaysHospitalCases: Int? {
		didSet {
			todaysHospitalCasesPretty = todaysHospitalCases != nil ? "\(todaysHospitalCases!.withCommas())" : "-"
		}
	}
	
	@Published var todaysCasesPretty: String = "-"
	@Published var todaysDeathsPretty: String = "-"
	@Published var todaysHospitalCasesPretty: String = "-"
	
	var weeklyCasesDelta: Int? {
		didSet {
			guard let weeklyCasesDelta = weeklyCasesDelta else {
				weeklyCasesDeltaPretty = "-"
				return
			}
			weeklyCasesDeltaPretty = weeklyCasesDelta >= 0 ? "+\(weeklyCasesDelta.withCommas())" : "\(weeklyCasesDelta.withCommas())"
		}
	}
	
	var weeklyDeathsDelta: Int? {
		didSet {
			guard let weeklyDeathsDelta = weeklyDeathsDelta else {
				weeklyDeathsDeltaPretty = "-"
				return
			}
			weeklyDeathsDeltaPretty = weeklyDeathsDelta >= 0 ? "+\(weeklyDeathsDelta.withCommas())" : "\(weeklyDeathsDelta.withCommas())"
		}
	}
	
	var weeklyHospitalCasesDelta: Int? {
		didSet {
			guard let weeklyHospitalCasesDelta = weeklyHospitalCasesDelta else {
				weeklyHospitalCasesDeltaPretty = "-"
				return
			}
			weeklyHospitalCasesDeltaPretty = weeklyHospitalCasesDelta >= 0 ? "+\(weeklyHospitalCasesDelta.withCommas())" : "\(weeklyHospitalCasesDelta.withCommas())"
		}
	}
	
	@Published var weeklyCasesDeltaPretty: String = "-"
	@Published var weeklyDeathsDeltaPretty: String = "-"
	@Published var weeklyHospitalCasesDeltaPretty: String = "-"
	
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
	
	var title: String {
		switch region {
		case .nationwide:
			return "Nationwide"
		case .localAuthority(let name, _):
			return name.capitalized
		}
	}
	
	var showHospitalCases: Bool {
		switch region {
		case .nationwide:
			return true
		case .localAuthority(_, _):
			return false
		}
	}
	
	private let statisticsFetcher: StatisticsFetchable
	private var disposables = Set<AnyCancellable>()
	
	private let region: StatisticsRegion
	
	// MARK: - Init
	init(statisticsFetcher: StatisticsFetchable = StatisticsFetcher(),
		 region: StatisticsRegion) {
		self.statisticsFetcher = statisticsFetcher
		self.region = region
		fetchStatistics()
	}
	
	// MARK: - Fetch
	func fetchStatistics() {
		statisticsFetcher.fetchStatistics(region: region)
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
		
		if dailyCases.count > 0 {
			self.todaysCases = dailyCases.last!.numberOfCases
		}
		
		if dailyCases.count > 7 {
			self.weeklyCasesDelta = todaysCases! - dailyCases[dailyCases.count - 8].numberOfCases
		}
	}
	
	private func calculateDailyDeaths(dateRange: DateRangeOption  = .allTime) {
		var dailyDeaths = rawData.reversed().map { DailyDeathEntry(numberOfDeaths: $0.newDeaths28DaysByPublishDate ?? 0,
																   date: $0.date) }
		dailyDeaths.removeTrailingEmptyEntries(for: \.numberOfDeaths)
		dailyDeaths.removeLeadingEmptyEntries(for: \.numberOfDeaths)
		
		let cutOffDate = calculateCutOffDate(dateRange: dateRange)
		let dateRange = cutOffDate...Date()
		dailyDeaths = dailyDeaths.filter({ dateRange.contains($0.date) })
		
		self.dailyDeaths = dailyDeaths
		
		if dailyDeaths.count > 0 {
			self.todaysDeaths = dailyDeaths.last!.numberOfDeaths
		}
		
		if dailyDeaths.count > 7 {
			self.weeklyDeathsDelta = todaysDeaths! - dailyDeaths[dailyDeaths.count - 8].numberOfDeaths
		}
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
		
		if hospitalCases.count > 0 {
			self.todaysHospitalCases = hospitalCases.last!.numberOfHospitalCases
		}
		
		if hospitalCases.count > 7 {
			self.weeklyHospitalCasesDelta = todaysHospitalCases! - hospitalCases[hospitalCases.count - 8].numberOfHospitalCases
		}
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

enum StatisticsRegion: Equatable {
	case nationwide
	case localAuthority(name: String, code: String)
}
