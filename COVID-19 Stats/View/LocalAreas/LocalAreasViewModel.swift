//
//  LocalAreasViewModel.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import Foundation
import SwiftUI

class LocalAreasViewModel: ObservableObject {
	
	private var userDefaultsManager: UserDefaultsManagerProtocol
	
	// MARK: - Init
	init(userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()) {
		self.userDefaultsManager = userDefaultsManager
	}
	
	// MARK: - Local Storage
	func deleteResponses(indexSet: IndexSet) {
		do {
			var savedResponses = try JSONDecoder().decode([LocalAuthorityResponse].self, from: userDefaultsManager.savedLocalAuthorityResponsesData)
			savedResponses.remove(atOffsets: indexSet)
			let savedResponsesData = try JSONEncoder().encode(savedResponses)
			userDefaultsManager.savedLocalAuthorityResponsesData = savedResponsesData
		} catch { }
		
	}
	
	func savedLocalAuthorityResponses(data: Data) -> [LocalAuthorityResponse] {
		do {
			return try JSONDecoder().decode([LocalAuthorityResponse].self, from: data)
		} catch {
			return []
		}
	}
}
