//
//  SearchLocationViewModelTest.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Testing
@testable import Places
import CoreLocation
import MapKit


@MainActor
struct SearchLocationViewModelTest {

    private let sut: SearchLocationViewModel
    
    init() {
        sut = SearchLocationViewModel()
    }
    
    @Test func performSearchWithValidCoordinates() async {
        let latitude = 40.7128
        let longitude = -74.0060
        
        sut.latitude = String(latitude)
        sut.longitude = String(longitude)
        await sut.performSearch()
        #expect(sut.location != nil)
        #expect(sut.location?.latitude == latitude)
        #expect(sut.location?.longitude == longitude)
     }
    
    
    @Test func performSearchWithInvalidLatitude() async {
        sut.latitude = "999"
        sut.longitude = "-74.0060"
        
        await sut.performSearch()
        
        #expect(sut.location == nil)
        #expect(sut.errorMessage == "search_location_error_invalid_input".localized())
    }
    
    
    @Test func performSearchWithInvalidLongitude() async {
        sut.latitude = "40.7128"
        sut.longitude = "999"

        await sut.performSearch()

        #expect(sut.location == nil)
        #expect(sut.errorMessage == "search_location_error_invalid_input".localized())
    }

    @Test func performSearchWithEmptyNameAndEmptyCoordinates() async {
        await sut.performSearch()
        
        #expect(sut.location == nil)
        #expect(!sut.errorMessage.isEmpty)
     }
    
    @Test func performSearchWithLocationNameUsesGeocoderResult() async {
        let coordinate = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        let placemark = MKPlacemark(coordinate: coordinate)
        let geocoder = MockGeocodingService()
        geocoder.placemarksToReturn = [placemark]
        let sut = SearchLocationViewModel(geocoder: geocoder)

        sut.locationName = "Paris"
        await sut.performSearch()

        #expect(sut.location?.name == "Paris")
        #expect(sut.location?.latitude == coordinate.latitude)
        #expect(sut.location?.longitude == coordinate.longitude)
    }
    
    @Test func performSearchWithLocationNameSetsNotFoundWhenNoPlacemarksReturned() async {
        let geocoder = MockGeocodingService()
        geocoder.placemarksToReturn = []
        let sut = SearchLocationViewModel(geocoder: geocoder)

        sut.locationName = "Nowhereville"
        await sut.performSearch()

        #expect(sut.location == nil)
        #expect(sut.errorMessage == "location_not_found".localized())
    }
    
    @Test func performSearchWithLocationNameSetsNotFoundWhenGeocoderThrows() async {
        let geocoder = MockGeocodingService()
        geocoder.errorToThrow = NSError(domain: "SearchLocationViewModelTest", code: 1)
        let sut = SearchLocationViewModel(geocoder: geocoder)

        sut.locationName = "Paris"
        await sut.performSearch()

        #expect(sut.location == nil)
        #expect(sut.errorMessage == "location_not_found".localized())
    }

    
    @Test func settingLocationNameClearsExistingCoordinates() {
           sut.latitude = "40.7128"
           sut.longitude = "-74.0060"

           sut.locationName = "New York"

           #expect(sut.latitude.isEmpty)
           #expect(sut.longitude.isEmpty)
       }
    
    @Test func settingLatitudeClearsExistingLocationName() {
          sut.locationName = "New York"

          sut.latitude = "40.7128"

          #expect(sut.locationName.isEmpty)
      }

    
    @Test func settingLongitudeClearsExistingLocationName() {
        sut.locationName = "New York"

        sut.longitude = "-74.0060"

        #expect(sut.locationName.isEmpty)
    }

    @Test func isLatitudeInvalid() {
        sut.latitude = "999"
        #expect(sut.isLatitudeInvalid == true)

        sut.latitude = "45.0"
        #expect(sut.isLatitudeInvalid == false)
    }

    @Test func isLongitudeInvalid() {
          sut.longitude = "999"
          #expect(sut.isLongitudeInvalid == true)

          sut.longitude = "-45.0"
          #expect(sut.isLongitudeInvalid == false)
      }
}

/// Deterministic test double for `GeocodingServiceProtocol` — avoids real network calls
/// through `CLGeocoder` when testing `SearchLocationViewModel.searchByName()`.
private final class MockGeocodingService: GeocodingServiceProtocol {
    var placemarksToReturn: [CLPlacemark] = []
    var errorToThrow: Error?
    
    func geocodeAddressString(_ address: String) async throws -> [CLPlacemark] {
        if let errorToThrow {
            throw errorToThrow
        }
        return placemarksToReturn
    }
}
