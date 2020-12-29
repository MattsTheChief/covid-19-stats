//
//  AddAreaView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import SwiftUI

struct AddAreaView: View {
	
	@ObservedObject var viewModel: AddAreaViewModel
	@Binding var isBeingPresented: Bool
	
	// MARK: - Views
    var body: some View {
		
		switch viewModel.state {
		case .success:
			isBeingPresented = false
		default:
			break
		}
		
		return NavigationView {
			Form {

				Section(header: Text("POSTCODE"),
						footer: Text("Your postcode is used to find your local authority and never leaves your device")) {
					
					TextField("Enter postcode", text: $viewModel.postcode)
					
					if viewModel.state == .invalidPostcode {
						Text("Please enter a valid postcode")
							.foregroundColor(.red)
					}
				}
				
				Section {
					HStack {
						if viewModel.state == .loading {
							ProgressView()
						} else {
							Button(action: {
								viewModel.fetchLocalAuthority()
							}) {
								Text("Add")
							}
						}
					}
				}
				
			}
			.navigationTitle("Add Area")
			.navigationBarItems(trailing:
				Button(action: {
					isBeingPresented = false
				}) {
					Text("Close")
				}
			)
			.alert(isPresented: .constant(viewModel.showAlert)) {
				switch viewModel.state {
				case .areaAlreadyAdded:
					return Alert(title: Text("Area already saved"),
								 message: Text("This area is already in your Saved Areas list."),
								 dismissButton: .default(Text("OK")))
				default:
					return Alert(title: Text("Unable to save area"),
								 message: Text("This area cannot be saved right now. Please try again later."),
								 dismissButton: .default(Text("OK")))
				}
			}
		}
    }
	
}

struct AddPostcodeView_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = AddAreaViewModel()
		viewModel.state = .loading
		return AddAreaView(viewModel: viewModel, isBeingPresented: .constant(true))
    }
}
