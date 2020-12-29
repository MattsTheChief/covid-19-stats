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
	
    var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				
				TodaysStatisticsView(viewModel: viewModel)
					.padding()
				
				Text("Historic")
					.font(.title)
					.bold()
					.padding([.horizontal, .top])
				
				Picker(selection: $viewModel.selectedDateRange, label: Text("Select date range")) {
					ForEach(0 ..< viewModel.dateRangeOptions.count) { index in
						Text(viewModel.dateRangeOptions[index]).tag(index)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding(.horizontal)

				LineView(data: viewModel.dailyCases.map { Double($0.numberOfCases) },
						 title: "Daily Cases",
						 legend: viewModel.dailyCasesLegend)
					.frame(height: 320)
					.padding([.bottom, .horizontal])
				
				LineView(data: viewModel.dailyDeaths.map { Double($0.numberOfDeaths) },
						 title: "Daily Deaths",
						 legend: viewModel.dailyDeathsLegend)
					.frame(height: 320)
					.padding()

				if viewModel.showHospitalCases {
					LineView(data: viewModel.hospitalCases.map { Double($0.numberOfHospitalCases) },
							 title: "Hospital Cases",
							 legend: viewModel.hospitalCasesLegend)
						.frame(height: 320)
						.padding()
				}
				
			}
		}
		.navigationTitle(viewModel.title)
    }
}

struct NationwideView_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = StatisticsViewModel(region: .nationwide)
		StatisticsView(viewModel: viewModel)
    }
}
