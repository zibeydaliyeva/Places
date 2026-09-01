//
//  APIServiceTest.swift
//  PlacesTests
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Testing
@testable import Places
internal import Foundation

struct APIServiceTest {

    private let sut: APIServiceProtocol = MockAPIService()
    
    @Test func getLocationsReturnsLocationsFromFixture() async throws {
        let data = try await sut.getLocations()
        #expect(!data.locations.isEmpty)
        #expect(data.locations.count == 4)
    }
}

final class MockAPIService: APIServiceProtocol {
    
    func getLocations() async throws -> Places.LocationsResponse {
        guard let data = dataFromTestBundleFile(fileName: "Locations", withExtension: "json") else {
            throw NetworkError.defaultError("File not found")
        }
        
        do {
            return try JSONDecoder().decode(Places.LocationsResponse.self, from: data)
        } catch {
            throw NetworkError.parseError
        }
    }
    
    private func dataFromTestBundleFile(
        fileName: String,
        withExtension fileExtension: String
    ) -> Data? {
        let testBundle = Bundle(for: BundleLocator.self)
        
        guard let resourceURL = testBundle.url(
            forResource: fileName,
            withExtension: fileExtension
        ) else {
            return nil
        }
        
        return try? Data(contentsOf: resourceURL)
    }
}

/// Used to locate resources in the test bundle.
private final class BundleLocator {}
