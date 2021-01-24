//
//  InfoView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import SwiftUI

struct InfoView: View {
		
	@ObservedObject var viewModel: InfoViewModel
	
    var body: some View {
		NavigationView {
			List {
				Section {
					NavigationLink(destination: AcknowledgementsView()) {
						Text("Acknowledgements")
					}
				}
				
				Section {
					Text(viewModel.versionPretty)
						.foregroundColor(Color.gray)
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Info")
		}
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
		InfoView(viewModel: InfoViewModel())
    }
}
