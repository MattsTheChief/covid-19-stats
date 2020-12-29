//
//  TodaysStatsView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import SwiftUI

struct TodaysStatsView: View {
	
	@ObservedObject var viewModel: NationwideViewModel
	
    var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Today")
				.font(.title)
				.bold()
			HStack {
				VStack(alignment: .leading, spacing: 5) {
					Text("Daily Cases")
					Text("Daily Deaths")
					Text("Hospital Cases")
				}.font(.headline)
				Spacer()
				VStack(alignment: .leading, spacing: 5) {
					HStack {
						Text(viewModel.todaysCasesPretty)
							.font(.body)
						Text(viewModel.weeklyCasesDeltaPretty)
							.font(.subheadline)
					}
					HStack {
						Text(viewModel.todaysDeathsPretty)
							.font(.body)
						Text(viewModel.weeklyDeathsDeltaPretty)
							.font(.subheadline)
					}
					HStack {
						Text(viewModel.todaysHospitalCasesPretty)
							.font(.body)
						Text(viewModel.weeklyHospitalCasesDeltaPretty)
							.font(.subheadline)
					}
				}.font(.headline)
				Spacer()
			}
		}
    }
}

struct TodaysStatsView_Previews: PreviewProvider {
    static var previews: some View {
		TodaysStatsView(viewModel: NationwideViewModel())
    }
}
