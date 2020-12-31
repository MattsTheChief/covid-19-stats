//
//  StatisticsView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import SwiftUI
import Combine
import SwiftUICharts

struct StatisticsView: View {
	
	@ObservedObject var viewModel: StatisticsViewModel
	
	private let chartStyle = ChartStyle(
		backgroundColor: Color.white,
		accentColor: Color.accentColor,
		secondGradientColor: Color.accentColor,
		textColor: Color.black,
		legendTextColor: Color.gray,
		dropShadowColor: Color.gray
	)
	
	private let darkChartStyle = ChartStyle(
		backgroundColor: Color.black,
		accentColor: Color.accentColor,
		secondGradientColor: Color.accentColor,
		textColor: Color.white,
		legendTextColor: Color.white,
		dropShadowColor: Color.gray
	)
	
    var body: some View {
		
		chartStyle.darkModeStyle = darkChartStyle
		
		return ScrollView {
			LazyVStack(alignment: .leading) {
				
				TodaysStatisticsView(viewModel: viewModel)
					.padding()
				
				Text("Historic")
					.font(.title)
					.bold()
					.padding([.horizontal, .top])
				
				Picker(selection: $viewModel.selectedDateRangeIndex, label: Text("Select date range")) {
					ForEach(0 ..< viewModel.dateRangeOptions.count) { index in
						Text(viewModel.dateRangeOptions[index]).tag(index)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding(.horizontal)

				LineView(data: viewModel.dailyCases.map { ($0.prettyDate, Double($0.numberOfCases)) },
						 title: "Daily Cases",
						 legend: viewModel.dailyCasesLegend,
						 style: chartStyle,
						 valueSpecifier: "%.0f")
					.frame(height: 350)
					.padding([.bottom, .horizontal])
				
				LineView(data: viewModel.dailyDeaths.map { ($0.prettyDate, Double($0.numberOfDeaths)) },
						 title: "Daily Deaths",
						 legend: viewModel.dailyDeathsLegend,
						 style: chartStyle,
						 valueSpecifier: "%.0f")
					.frame(height: 350)
					.padding()

				if viewModel.showHospitalCases {
					LineView(data: viewModel.hospitalCases.map { ($0.prettyDate, Double($0.numberOfHospitalCases)) },
							 title: "Hospital Cases",
							 legend: viewModel.hospitalCasesLegend,
							 style: chartStyle,
							 valueSpecifier: "%.0f")
						.frame(height: 350)
						.padding()
				}
				
			}
		}
		.navigationTitle(viewModel.title)
		.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
			viewModel.fetchStatistics()
		}
    }
}

struct NationwideView_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = StatisticsViewModel(region: .nationwide)
		StatisticsView(viewModel: viewModel)
    }
}
