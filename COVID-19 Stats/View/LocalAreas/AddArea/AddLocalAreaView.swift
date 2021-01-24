//
//  AddLocalAreaView.swift
//  COVID-19 Stats
//
//  Created by Matt Lee on 29/12/2020.
//

import SwiftUI

struct AddLocalAreaView: View {
	
	@ObservedObject var viewModel: AddLocalAreaViewModel
	@Binding var isBeingPresented: Bool
	
	// MARK: - Views
    var body: some View {
		
		NavigationView {
			
			Form {

				Section(header: Text("POSTCODE"),
						footer: Text("Your postcode is used to find your local authority and is not stored outside of your device")) {
					
					TextField("Enter postcode", text: $viewModel.postcode)
					
					if viewModel.state == .invalidPostcode {
						Text("Please enter a valid UK postcode")
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
			.navigationTitle("Add Local Area")
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
								 message: Text("Please check the postcode entered is correct."),
								 dismissButton: .default(Text("OK")))
				}
			}
		}
		.onChange(of: viewModel.state) { value in
			switch value {
			case .success:
				isBeingPresented = false
			default:
				break
			}
		}
    }
	
}

struct AddLocalAreaView_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = AddLocalAreaViewModel()
		viewModel.state = .loading
		return AddLocalAreaView(viewModel: viewModel, isBeingPresented: .constant(true))
    }
}
