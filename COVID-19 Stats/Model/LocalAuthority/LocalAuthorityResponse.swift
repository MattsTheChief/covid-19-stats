//
//  LocalAuthorityResponse.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import Foundation

// MARK: - LocalAuthorityResponse
struct LocalAuthorityResponse: Codable {
	let data: ResponseData
	
	struct ResponseData: Codable {
		let attributes: DataAttributes
		let id: String
	}
	
	struct DataAttributes: Codable {
		let localAuthorityCode: String
		let localAuthorityName: String
		let postcode: String

		enum CodingKeys: String, CodingKey {
			case localAuthorityCode = "laua"
			case localAuthorityName = "laua_name"
			case postcode = "pcd"
		}
	}
	
	// MARK: - Convenience Properties
	var id: String {
		data.id
	}
	
	var localAuthorityCode: String {
		data.attributes.localAuthorityCode
	}
	
	var localAuthorityName: String {
		data.attributes.localAuthorityName
	}
	var postcode: String {
		data.attributes.postcode
	}
}

extension LocalAuthorityResponse: Equatable {
	
	static func == (lhs: LocalAuthorityResponse, rhs: LocalAuthorityResponse) -> Bool {
		lhs.localAuthorityCode == rhs.localAuthorityCode
	}
	
}
