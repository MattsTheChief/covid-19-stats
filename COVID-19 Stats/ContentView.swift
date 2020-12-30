//
//  ContentView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import SwiftUI

struct ContentView: View {
	
    var body: some View {
		TabView {
			NationwideStatisticsView()
				.tabItem {
					Image(systemName: "flag")
					Text("Nationwide")
				}
			SavedAreasView(viewModel: SavedAreasViewModel())
				.tabItem {
					Image(systemName: "mappin.and.ellipse")
					Text("Local")
				}
			InfoView(viewModel: InfoViewModel())
			  .tabItem {
				 Image(systemName: "info.circle")
				 Text("Info")
			   }
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
