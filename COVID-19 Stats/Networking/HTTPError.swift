//
//  HTTPError.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import Foundation

enum HTTPError: Error, ExpressibleByIntegerLiteral {
	case badRequest(description: String?)
	case unauthorized(description: String?)
	case notFound(description: String?)
	case serverError(description: String?)
	case unprocessableRequest(description: String?)
	case unknown(description: String?)
}

// MARK: - ExpressibleByIntegerLiteral
extension HTTPError {
	init(integerLiteral value: Int) {
		self = .init(code: value, description: nil)
	}
}

// MARK: - Init
extension HTTPError {
	init(code: Int, description: String?) {
		switch code {
		case 400:
			self = .badRequest(description: description)
		case 401:
			self = .unauthorized(description: description)
		case 404:
			self = .notFound(description: description)
		case 422:
			self = .unprocessableRequest(description: description)
		case 500:
			self = .serverError(description: description)
		default:
			self = .unknown(description: description)
		}
	}
}
