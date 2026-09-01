//
//  SearchLocationViewModel.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//


import Foundation
import Observation
import CoreLocation

protocol GeocodingServiceProtocol {
    func geocodeAddressString(_ address: String) async throws -> [CLPlacemark]
}

extension CLGeocoder: GeocodingServiceProtocol {}

@Observable
final class SearchLocationViewModel {
    
    var location: Location?
    
    var locationName: String = "" {
        didSet { clearCoordinatesIfNeeded() }
    }
    
    var latitude: String = "" {
        didSet { clearLocationNameIfNeeded()}
    }
    
    var longitude: String = "" {
        didSet { clearLocationNameIfNeeded() }
    }
    
    var isLatitudeInvalid: Bool {
        CoordinateAxis.latitude.isInvalid(from: latitude)
    }
    
    var isLongitudeInvalid: Bool {
        CoordinateAxis.longitude.isInvalid(from: longitude)
    }
    
    private(set) var errorMessage = ""
    
    private(set) var isSearching = false
    
    private let geocoder: GeocodingServiceProtocol
    
    init(geocoder: GeocodingServiceProtocol = CLGeocoder()) {
        self.geocoder = geocoder
    }
    
    func performSearch() async {
        guard !isSearching else { return }
        isSearching = true
        defer { isSearching = false }
        
        if !locationName.isEmpty {
            await searchByName()
        } else if !isLatitudeInvalid && !isLongitudeInvalid {
            searchByCoordinates()
        } else {
            errorMessage = "search_location_error_invalid_input".localized()
        }
    }
    
    private func searchByCoordinates() {
        guard
            let lat = CoordinateAxis.latitude.value(from: latitude),
            let lon = CoordinateAxis.longitude.value(from: longitude)
        else {
            errorMessage = "search_location_error_invalid_input".localized()
            return
        }
        
        location = Location(name: locationName, latitude: lat, longitude: lon)
    }
    
    private func searchByName() async {
        do {
            let placemarks = try await geocoder.geocodeAddressString(locationName)
            guard let coordinate = placemarks.first?.location?.coordinate else {
                errorMessage = "location_not_found".localized()
                return
            }
            location = Location(
                name: locationName,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude)
        } catch {
            errorMessage = "location_not_found".localized()
        }
    }
    
    private func clearCoordinatesIfNeeded() {
        guard !locationName.isEmpty,
              !latitude.isEmpty || !longitude.isEmpty
        else { return }
        latitude = ""
        longitude = ""
    }
    
    private func clearLocationNameIfNeeded() {
        guard !locationName.isEmpty,
                  !latitude.isEmpty || !longitude.isEmpty
        else { return }
        locationName = ""
    }
}
