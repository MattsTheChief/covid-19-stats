//
//  AcknowledgementsView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 31/12/2020.
//

import SwiftUI

struct AcknowledgementsView: View {
    var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 12) {
				
				Text("All data shown is obtained from GOV.UK.")
				
				Button(action: {
					let url = URL(string: "https://github.com/MattsTheChief/ChartView")!
					UIApplication.shared.open(url)
				}) {
					Text("This app makes use of a modified version of AppPear's open-source library ChartView, that can be found ")
					+ Text("here")
						.foregroundColor(Color.blue)
					+ Text(".")
				}
				.foregroundColor(Color(.label))
				
				Button(action: {
					let url = URL(string: "https://www.flaticon.com/authors/surang")!
					UIApplication.shared.open(url)
				}) {
					Text("Certain assets used in the app icon are made by ")
					+ Text("surang from www.flaticon.com")
						.foregroundColor(Color.blue)
					+ Text(".")
				}
				.foregroundColor(Color(.label))
				
			}.padding()
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.navigationTitle("Acknowledgements")
    }
}

struct AcknowledgementsView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			AcknowledgementsView()
		}
    }
}
