//
//  InfoViewModel.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 30/12/2020.
//

import Foundation

class InfoViewModel: ObservableObject {
	
	let privacyPolicyURL: URL = URL(string: "https://covid-19-stats-uk.flycricket.io/privacy.html")!
	
	let versionPretty: String = {
		guard let rawVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return ""
		}
		
		return "v" + rawVersion
	}()
	
}
