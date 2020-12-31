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
					
					NavigationLink(destination: Text("Terms & Conditions")) {
						Text("Terms & Conditions")
					}
					
					NavigationLink(destination: Text("Privacy Policy")) {
						Text("Privacy Policy")
					}
					
					NavigationLink(destination: AcknowledgementsView()) {
						Text("Acknowledgements")
					}
					
					NavigationLink(destination: ContactUsView()) {
						Text("Contact Us")
					}
					
					Text(viewModel.versionPretty)
					
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
