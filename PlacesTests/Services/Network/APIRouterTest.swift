//
//  APIRouterTest.swift
//  PlacesTests
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Testing
@testable import Places
internal import Foundation

struct APIRouterTest {

    @Test func getLocationsRequest() throws {
        let router = APIRouter.getLocations
        let request = try router.request()
        #expect(request.allHTTPHeaderFields != nil)
        let value = request.value(forHTTPHeaderField: "Content-Type")
        #expect(value == "application/json")
    }

}
