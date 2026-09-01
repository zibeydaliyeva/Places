//
//  LocationsViewModelTest.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Testing
@testable import Places
internal import Foundation

@MainActor
struct LocationsViewModelTest {
    
    private let sut: LocationsViewModel
    private let apiService: APIServiceProtocol
    private let deepLink: DeepLinkServiceProtocol
    
    init() throws {
        apiService = MockAPIService()
        deepLink = DeepLinkService()
        
        sut = LocationsViewModel(service: apiService, deepLink: deepLink)
    }

    
    @Test func fetchLocations() async {
        await sut.fetchLocations()
        
        guard case let .loaded(data) = sut.state else {
            Issue.record("Expected state to be .loaded, got \(sut.state)")
            return
        }
        #expect(data.locations.count == 4)
    }

    @Test func appURL() async throws {
          await sut.fetchLocations()
          guard case let .loaded(data) = sut.state else {
              Issue.record("Expected state to be .loaded")
              return
          }
          let location = data.locations[0]
          let baseAppURL = sut.deepLink.baseAppURL
          let expectedURLString = "\(baseAppURL)?lat=\(location.latitude)&lon=\(location.longitude)"

          let url = sut.appURL(for: location)
          #expect(url != nil)
          #expect(url?.absoluteString == expectedURLString)
      }
    
    
    @Test func webURL() async throws {
        await sut.fetchLocations()
        guard case let .loaded(data) = sut.state else {
            Issue.record("Expected state to be .loaded")
            return
        }
        let location = data.locations[0]
        let baseWebURL = sut.deepLink.baseWebURL

        let url = sut.webURL(for: location)
        if let locationName = location.name {
            let nameWithPercentage = locationName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            let expectedURLString = baseWebURL + nameWithPercentage
            #expect(url != nil)
            #expect(url?.absoluteString == expectedURLString)
        }
    }

    @Test func fetchLocationsSetsFailedStateOnServiceError() async {
        let failingSUT = LocationsViewModel(service: ThrowingAPIService(), deepLink: DeepLinkService())
        
        await failingSUT.fetchLocations()
        
        guard case let .failed(message) = failingSUT.state else {
            Issue.record("Expected state to be .failed, got \(failingSUT.state)")
            return
        }
        #expect(message == NetworkError.serverError.localizedDescription)
    }
    
    @Test func fetchLocationsIgnoresConcurrentCallWhileAlreadyLoading() async {
        let delayedSUT = LocationsViewModel(service: DelayedAPIService(), deepLink: DeepLinkService())
        
        async let firstFetch: () = delayedSUT.fetchLocations()
        // Give the first call time to synchronously flip state to `.loading`
        // before firing a second, overlapping call.
        try? await Task.sleep(nanoseconds: 20_000_000)
        #expect(delayedSUT.state.isLoading)
        
        await delayedSUT.fetchLocations() // Should be a no-op due to the `!state.isLoading` guard.
        await firstFetch
        
        guard case .loaded = delayedSUT.state else {
            Issue.record("Expected state to end up .loaded, got \(delayedSUT.state)")
            return
        }
    }
}


/// Always throws, used to exercise `LocationsViewModel`'s `.failed` state branch.
private struct ThrowingAPIService: APIServiceProtocol {
    func getLocations() async throws -> LocationsResponse {
        throw NetworkError.serverError
    }
}


/// Delays before succeeding, used to give tests a window to assert `.loading` state
/// and to exercise the `fetchLocations()` re-entrancy guard.
private struct DelayedAPIService: APIServiceProtocol {
    func getLocations() async throws -> LocationsResponse {
        try await Task.sleep(nanoseconds: 200_000_000)
        return LocationsResponse(locations: [])
    }
}
