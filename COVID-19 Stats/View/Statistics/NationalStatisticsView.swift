//
//  NationalStatisticsView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import SwiftUI

struct NationalStatisticsView: View {
    var body: some View {
		NavigationView {
			let viewModel = StatisticsViewModel(region: .national)
			StatisticsView(viewModel: viewModel)
		}
    }
}

struct NationalStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        NationalStatisticsView()
    }
}
