//
//  TodaysStatsView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import SwiftUI

struct TodaysStatsView: View {
	
	@ObservedObject var viewModel: NationwideViewModel
	
	private func deltaLabel(text: String, rawValue: Int?) -> some View {
		
		var textColor: Color = .primary
		
		if let rawValue = rawValue {
			textColor = rawValue >= 0 ? .red : .green
		}
		
		return HStack(spacing: 0) {
			Text("(")
			Text(text)
				.foregroundColor(textColor)
			Text(" v last week)")
		}
		.font(.subheadline)
	}
	
    var body: some View {
		VStack(alignment: .leading) {
			Text("Today")
				.font(.title)
				.bold()
			GroupBox {
				VStack(alignment: .leading, spacing: 10) {
					HStack {
						VStack(alignment: .leading, spacing: 24) {
							Text("Daily Cases")
							Text("Daily Deaths")
							Text("Hospital Cases")
						}.font(.headline)
						Spacer()
						VStack(spacing: 5) {
							VStack {
								Text(viewModel.todaysCasesPretty)
									.font(.body)
									.bold()
								deltaLabel(text: viewModel.weeklyCasesDeltaPretty,
										   rawValue: viewModel.weeklyCasesDelta)
							}
							VStack {
								Text(viewModel.todaysDeathsPretty)
									.font(.body)
									.bold()
								deltaLabel(text: viewModel.weeklyDeathsDeltaPretty,
										   rawValue: viewModel.weeklyDeathsDelta)
							}
							VStack {
								Text(viewModel.todaysHospitalCasesPretty)
									.font(.body)
									.bold()
								deltaLabel(text: viewModel.weeklyHospitalCasesDeltaPretty,
										   rawValue: viewModel.weeklyHospitalCasesDelta)
							}
						}.font(.headline)
						Spacer()
					}
				}
			}
		}
    }
}

struct TodaysStatsView_Previews: PreviewProvider {
    static var previews: some View {
		TodaysStatsView(viewModel: NationwideViewModel())
    }
}
