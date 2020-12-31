//
//  ContactUsView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 31/12/2020.
//

import SwiftUI

struct ContactUsView: View {
    var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 12) {
				
				Text("If you have any questions or would like to give feedback, please email covid19statsuk@gmail.com.")
					.foregroundColor(Color(.label))
				
			}.padding()
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.navigationTitle("Contact Us")
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			ContactUsView()
		}
    }
}
