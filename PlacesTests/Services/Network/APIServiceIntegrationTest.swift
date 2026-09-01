//
//  APIServiceIntegrationTest.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Testing
@testable import Places

@MainActor
struct APIServiceIntegrationTest {
    
    @Test func getLocationsFromLiveServerReturnsLocations() async throws {
        let sut = APIService()
        let data = try await sut.getLocations()
        #expect(!data.locations.isEmpty)
    }
    
}
