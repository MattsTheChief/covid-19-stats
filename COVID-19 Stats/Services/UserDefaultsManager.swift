//
//  UserDefaultsManager.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import Foundation

struct UserDefaultsManager: UserDefaultsManagerProtocol {
	
	let userDefaults: UserDefaults
	
	static let savedLocalAuthorityResponsesDataKey: String = "savedLocalAuthorityResponsesDataKey"

	// MARK: - Init
	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
	}
	
	// MARK: - UserDefaultsManagerProtocol
	public var savedLocalAuthorityResponsesData: Data {
		get {
			return (userDefaults.object(forKey: UserDefaultsManager.savedLocalAuthorityResponsesDataKey) as? Data) ?? Data()
		} set {
			save(value: newValue, key: UserDefaultsManager.savedLocalAuthorityResponsesDataKey)
		}
	}
	
	// MARK: - Save
	private func save(value: Any?, key: String) {
		
		if value != nil {
			userDefaults.set(value, forKey: key)
		} else {
			userDefaults.removeObject(forKey: key)
		}
		
		_ = userDefaults.synchronize()
	}
}

protocol UserDefaultsManagerProtocol {
	var savedLocalAuthorityResponsesData: Data { get set }
}
