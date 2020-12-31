//
//  InfoView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import SwiftUI

struct InfoView: View {
	
	@Environment(\.openURL) var openURL
	
	@ObservedObject var viewModel: InfoViewModel
	
    var body: some View {
		NavigationView {
			List {
				Section {
					
					Button(action: {
						openURL(viewModel.privacyPolicyURL)
					}){
						HStack {
							Text("Privacy Policy")
								.foregroundColor(Color(.label))
							Spacer()
							Image(systemName: "square.and.arrow.up")
								.foregroundColor(Color(.systemGray))
						}
					}
					
					NavigationLink(destination: TermsAndConditionsView()) {
						Text("Terms & Conditions")
					}
					
					NavigationLink(destination: AcknowledgementsView()) {
						Text("Acknowledgements")
					}
					
					NavigationLink(destination: ContactUsView()) {
						Text("Contact Us")
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
