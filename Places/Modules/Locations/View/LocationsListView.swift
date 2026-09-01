//
//  LocationsListView.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import SwiftUI

struct LocationsListView: View {
    
    @State var viewModel: LocationsViewModel
    
    @State private var isSearchPresented = false
    
    @Environment(\.openURL) private var openURL
    
    private let testingID = UIIdentifiers.LocationListScreen.self
    
    var body: some View {
        NavigationStack {
            LoadingStateView(loadingState: viewModel.state) { data in
                List(data.locations) { location in
                    LocationItemView(location: location)
                        .onTapGesture {
                            handleLocationSelection(for: location)
                        }
                }
                .accessibilityIdentifier(testingID.locationsList)
            } retryAction: {
                Task {
                    await viewModel.fetchLocations()
                }
            }
            
            .navigationTitle("places_title".localized())
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    searchButtonView
                }
            })
            .sheet(isPresented: $isSearchPresented, content: {
                SearchLocationView(viewModel: SearchLocationViewModel()) { location in
                    handleLocationSelection(for: location)
                }
            })
            .task {
                await viewModel.fetchLocations()
            }
        }
        
    }
    
    // MARK: - Subviews
    private var searchButtonView: some View {
        Button {
            isSearchPresented = true
        } label: {
            Image(systemName: "magnifyingglass")
        }
        .foregroundColor(.black)
        .accessibilityLabel("search".localized())
        .accessibilityHint("tap_to_find".localized())
        .accessibilityIdentifier(testingID.searchButton)
    }
    
    
    // MARK: - Functions
    private func handleLocationSelection(for location: Location) {
        guard let url = viewModel.appURL(for: location) else { return }
        openURL(url) { success in
            if !success, let webURL = viewModel.webURL(for: location) {
                openURL(webURL)
            }
        }
    }
    
}


