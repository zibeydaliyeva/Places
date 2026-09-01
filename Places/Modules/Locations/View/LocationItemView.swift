//
//  LocationItemView.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import SwiftUI

struct LocationItemView: View {
    let location: Location
    
    private let testingID = UIIdentifiers.LocationListScreen.self
    
    var body: some View {
        VStack(alignment: .leading) {
            nameView
            coordinatesView
        }
        .padding(.vertical, PlacesUI.spacing.xs)
        .accessibilityHint("tap_to_open".localized())
        .accessibilityIdentifier(testingID.item(location.id))
    }
    
    private var nameView: some View {
        Text(location.name ?? "unknown_location".localized())
            .font(.headline)
            .accessibilityLabel("location_name".localized(arguments: "\(location.name ?? "unknown")"))
    }
    
    private var coordinatesView: some View {
        Text("\(location.latitude); \(location.longitude)")
            .font(.subheadline)
            .accessibilityLabel("latitude_longitude".localized(arguments: location.latitude, location.longitude))
    }
}
