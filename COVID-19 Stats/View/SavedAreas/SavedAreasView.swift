//
//  SavedAreasView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 28/12/2020.
//

import SwiftUI

struct SavedAreasView: View {
	
	@ObservedObject var viewModel: SavedAreasViewModel
	
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
							NavigationLink(destination: Text("asd")) {
								Text(response.localAuthorityName)
							}
						}
						.onDelete(perform: delete)
					}.listStyle(InsetGroupedListStyle())
				} else {
					Text("No saved areas")
				}
			}
			.navigationTitle("Saved Areas")
			.navigationBarItems(leading: EditButton(), trailing:
				Button(action: {
					showingAddPostcodeScreen = true
				}) {
					Image(systemName: "plus").imageScale(.large)
				}
			)
		}.sheet(isPresented: $showingAddPostcodeScreen) {
			AddAreaView(viewModel: AddAreaViewModel(),
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

struct SavedAreasView_Previews: PreviewProvider {
    static var previews: some View {
		SavedAreasView(viewModel: SavedAreasViewModel())
    }
}
