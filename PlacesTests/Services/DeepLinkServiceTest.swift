//
//  DeepLinkServiceTest.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Testing
@testable import Places
internal import Foundation

struct DeepLinkServiceTest {
    
    private let sut = DeepLinkService()
    
    @Test func createAppURLBuildsCorrectURL() {
        let location = Location(name: "Paris", latitude: 48.8566, longitude: 2.3522)
        
        let url = sut.createAppURL(for: location)
        
        #expect(url != nil)
        #expect(url?.absoluteString == "wikipedia://places?lat=48.8566&lon=2.3522")
    }
    
    @Test func createWebURLBuildsCorrectURLWhenNameExists() {
        let location = Location(name: "New York", latitude: 40.7128, longitude: -74.0060)
        
        let url = sut.createWebURL(for: location)
        
        #expect(url != nil)
        #expect(url?.absoluteString == "https://en.wikipedia.org/wiki/New%20York")
    }
    
    @Test func createWebURLReturnsNilWhenNameIsNil() {
        let location = Location(name: nil, latitude: 40.7128, longitude: -74.0060)
        
        let url = sut.createWebURL(for: location)
        
        #expect(url == nil)
    }
    
}
