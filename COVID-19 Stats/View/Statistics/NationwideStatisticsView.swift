//
//  NationwideStatisticsView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import SwiftUI

struct NationwideStatisticsView: View {
    var body: some View {
		NavigationView {
			let viewModel = StatisticsViewModel(region: .nationwide)
			StatisticsView(viewModel: viewModel)
		}
    }
}

struct NationwideStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        NationwideStatisticsView()
    }
}
