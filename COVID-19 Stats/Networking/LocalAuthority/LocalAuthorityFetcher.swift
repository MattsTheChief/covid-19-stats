//
//  LocalAuthorityFetcher.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import Foundation
import Combine

class LocalAuthorityFetcher {
	
	private let session: URLSession
	
	// MARK: - Init
	init(session: URLSession = .shared) {
		self.session = session
	}
	
}

// MARK: - LocalAuthorityFetchable
extension LocalAuthorityFetcher: LocalAuthorityFetchable {
	
	func fetchLocalAuthority(postcode: String) -> AnyPublisher<LocalAuthorityResponse, Error> {
			
		var components = URLComponents()
		components.scheme = "https"
		components.host = "findthatpostcode.uk"
		components.path = "/postcodes/\(postcode).json"
		
		let request = URLRequest(url: components.url!)
		
		return session.dataTaskPublisher(for: request)
			
			.tryMap({ (data, response) -> Data in
				
				if let response = response as? HTTPURLResponse,
					(200..<300).contains(response.statusCode) == false {
					
					throw HTTPError(integerLiteral: response.statusCode)
					
				} else if let errorResponse = try? JSONDecoder().decode(LocalAuthorityErrorResponse.self, from: data) {

					throw errorResponse

				}

				return data
			})
			.decode(type: LocalAuthorityResponse.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
		
	}
	
}

protocol LocalAuthorityFetchable {
	func fetchLocalAuthority(postcode: String) -> AnyPublisher<LocalAuthorityResponse, Error>
}
