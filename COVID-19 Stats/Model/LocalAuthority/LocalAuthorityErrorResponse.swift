//
//  LocalAuthorityErrorResponse.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import Foundation

// MARK: - LocalAuthorityErrorResponse
struct LocalAuthorityErrorResponse: Error, Codable {
	let message: Message
	
	struct Message: Codable {
		let errors: [Error]
	}
	
	struct Error: Codable {
		let code, status, title: String
	}
}
