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
			NationwideView(viewModel: NationwideViewModel())
				.tabItem {
					Image(systemName: "chart.pie")
					Text("Nationwide")
				}
			SavedAreasView(viewModel: SavedAreasViewModel())
				.tabItem {
					Image(systemName: "mappin.and.ellipse")
					Text("Local")
				}
			SettingsView()
			  .tabItem {
				 Image(systemName: "gearshape")
				 Text("Settings")
			   }
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
