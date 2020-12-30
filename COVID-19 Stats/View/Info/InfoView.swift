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
					NavigationLink(destination: Text("Data Sources")) {
						Text("Data Sources")
					}
					
					NavigationLink(destination: Text("Terms & Condtions")) {
						Text("Terms & Condtions")
					}
					
					NavigationLink(destination: Text("Privacy Policy")) {
						Text("Privacy Policy")
					}
					
					NavigationLink(destination: Text("Icon made by surang(https://www.flaticon.com/authors/surang) from www.flaticon.com")) {
						Text("Acknowledgements")
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
