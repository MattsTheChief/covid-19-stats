//
//  LocalAreasView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import SwiftUI

struct LocalAreasView: View {
	
	@ObservedObject var viewModel: LocalAreasViewModel
	
	@AppStorage(UserDefaultsManager.savedLocalAuthorityResponsesDataKey)
	var savedLocalAuthorityResponsesData: Data = UserDefaultsManager().savedLocalAuthorityResponsesData
	
	@State var showingAddPostcodeScreen = false
	
	// MARK: - Views
    var body: some View {
		
		return NavigationView {
			Group {
				if savedLocalAuthorityResponses.count > 0 {
					List {
						ForEach(savedLocalAuthorityResponses, id: \.postcode) { response in
							let viewModel = StatisticsViewModel(region: .localAuthority(name: response.localAuthorityName, code: response.localAuthorityCode))
							NavigationLink(destination: StatisticsView(viewModel: viewModel)) {
								Text(response.localAuthorityName)
							}
						}
						.onDelete(perform: delete)
					}
					.listStyle(InsetGroupedListStyle())
				} else {
					Text("Tap \"+\" to add a Local Area")
				}
			}
			.navigationTitle("Local Areas")
			.navigationBarItems(leading: EditButton().opacity(savedLocalAuthorityResponses.count > 0 ? 1.0 : 0.0), trailing:
				Button(action: {
					showingAddPostcodeScreen = true
				}) {
					Image(systemName: "plus").imageScale(.large)
				}
			)
		}.sheet(isPresented: $showingAddPostcodeScreen) {
			AddLocalAreaView(viewModel: AddLocalAreaViewModel(),
							 isBeingPresented: $showingAddPostcodeScreen)
		}
    }
	
	func delete(at offsets: IndexSet) {
		viewModel.deleteResponses(indexSet: offsets)
	}
	
	// MARK: - Saved Local Authorities
	private var savedLocalAuthorityResponses: [LocalAuthorityResponse] {
		get {
			do {
				return try JSONDecoder().decode([LocalAuthorityResponse].self, from: savedLocalAuthorityResponsesData)
			} catch {
				return []
			}
		}
	}
}

struct LocalAreasView_Previews: PreviewProvider {
    static var previews: some View {
		LocalAreasView(viewModel: LocalAreasViewModel())
    }
}
