//
//  AddAreaViewModel.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import Foundation
import Combine
import SwiftUI

class AddAreaViewModel: ObservableObject {
	
	private let localAuthorityFetcher: LocalAuthorityFetchable
	private var userDefaultsManager: UserDefaultsManagerProtocol
	
	private var disposables = Set<AnyCancellable>()
	
	@Published var state: State = .idle
	@Published var postcode: String = "" {
		didSet {
			state = .idle
		}
	}
	var showAlert: Bool {
		switch state {
		case .areaAlreadyAdded, .unknownError:
			return true
		default:
			return false
		}
	}
	
	// MARK: - Init
	init(localAuthorityFetcher: LocalAuthorityFetchable = LocalAuthorityFetcher(),
		 userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()) {
		self.localAuthorityFetcher = localAuthorityFetcher
		self.userDefaultsManager = userDefaultsManager
	}
	
	// MARK: - Fetch
	func fetchLocalAuthority() {
		
		guard PostcodeValidator.validate(input: postcode) else {
			state = .invalidPostcode
			return
		}
		
		state = .loading
		
		localAuthorityFetcher.fetchLocalAuthority(postcode: postcode)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { [weak self] value in
					guard let weakSelf = self else {
						return
					}
					switch value {
					case .failure:
						weakSelf.state = .unknownError
					case .finished:
						break
					}
				},
				receiveValue: { [weak self] response in
					guard let weakSelf = self else {
						return
					}
					
					switch weakSelf.saveResponse(response) {
					case .success:
						UINotificationFeedbackGenerator().notificationOccurred(.success)
						weakSelf.state = .success
					case .failure(let error):
						switch error {
						case .alreadyExists:
							weakSelf.state = .areaAlreadyAdded
						default:
							weakSelf.state = .unknownError
						}
					}
					
				})
			.store(in: &disposables)
	}
	
	// MARK: - Local Storage
	private func saveResponse(_ response: LocalAuthorityResponse) -> Result<Bool, AddAreaError> {
		
		var responsesToSave: [LocalAuthorityResponse] = []
		
		do {
			responsesToSave = try JSONDecoder().decode([LocalAuthorityResponse].self, from: userDefaultsManager.savedLocalAuthorityResponsesData)
			
			guard !responsesToSave.contains(response) else {
				return .failure(.alreadyExists)
			}
			
			responsesToSave.append(response)
		} catch {
			responsesToSave = [response]
		}
		
		do {
			let responsesToSaveData = try JSONEncoder().encode(responsesToSave)
			userDefaultsManager.savedLocalAuthorityResponsesData = responsesToSaveData
		} catch {
			return .failure(.unknown)
		}
		
		return .success(true)
	}
	
}

extension AddAreaViewModel {
	enum State: Equatable {
		case idle
		case loading
		case invalidPostcode
		case areaAlreadyAdded
		case unknownError
		case success
	}
}

// MARK: - AddAreaError
enum AddAreaError: Error {
	case alreadyExists
	case unknown
}
