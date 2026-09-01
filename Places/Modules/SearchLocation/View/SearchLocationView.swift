//
//  SearchLocationView.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import SwiftUI

struct SearchLocationView: View {
    
    @State var viewModel: SearchLocationViewModel
    
    let onLocationSelected: (Location) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    private let testingID = UIIdentifiers.SearchLocationScreen.self
    
    
    init(viewModel: SearchLocationViewModel = SearchLocationViewModel(),
         onLocationSelected: @escaping (Location) -> Void = { _ in }) {
        self._viewModel = State(wrappedValue: viewModel)
        self.onLocationSelected = onLocationSelected
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: PlacesUI.spacing.sm) {
                Group {
                    sectionTitle("search_by_name".localized())
                    nameTextFieldView
                }
                
                orView
                
                Group {
                    sectionTitle("search_by_coordinate".localized())
                    latitudeTextFieldView
                    longitudeTextFieldView
                }
                
                searchButtonView
                
                if !viewModel.errorMessage.isEmpty {
                    errorMessageView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("search_location".localized())
            .padding()
        }
    }
    
    private var nameTextFieldView: some View {
        TextField("enter_name".localized(), text: $viewModel.locationName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .accessibilityLabel("enter_name".localized())
            .accessibilityIdentifier(testingID.nameField)
    }
    
    private var latitudeTextFieldView: some View {
        TextField("latitude".localized(), text: $viewModel.latitude)
            .textFieldStyle(RoundedBorderTextFieldStyle(isInvalid: viewModel.isLatitudeInvalid, keyboardType: .decimalPad))
            .accessibilityLabel("latitude".localized())
            .accessibilityIdentifier(testingID.latitudeField)
    }
    
    private var longitudeTextFieldView: some View {
        TextField("longitude".localized(), text: $viewModel.longitude)
            .textFieldStyle(RoundedBorderTextFieldStyle(isInvalid: viewModel.isLongitudeInvalid, keyboardType: .decimalPad))
            .accessibilityLabel("longitude".localized())
            .accessibilityIdentifier(testingID.longitudeField)
    }
    
    private var searchButtonView: some View {
        Button {
            performSearch()
        } label: {
            Group {
                if viewModel.isSearching {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("search".localized())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, PlacesUI.spacing.sm)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(PlacesUI.radiuses.small)
        }
        .disabled(viewModel.isSearching)
        .padding(.top, PlacesUI.spacing.sm)
        .accessibilityHint("tap_to_open".localized())
        .accessibilityIdentifier(testingID.searchButton)
    }
    
    private var orView: some View {
        ZStack(alignment: .center) {
            Divider()
                .background(Color.black)
            Text("or".localized())
                .font(.callout)
                .foregroundColor(.black)
                .padding(.horizontal)
                .background(Color.white)
                .padding()
        }
        .padding(.vertical, PlacesUI.spacing.xs)
    }
    
    private var errorMessageView: some View {
        Text(viewModel.errorMessage)
            .foregroundColor(.red)
            .padding()
            .accessibilityIdentifier(testingID.errorMessage)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.callout)
            .padding(.bottom, PlacesUI.spacing.xxs)
    }
    
    private func performSearch() {
        Task {
            await viewModel.performSearch()
            if let location = viewModel.location {
                onLocationSelected(location)
                dismiss()
            }
        }
        
    }
}
