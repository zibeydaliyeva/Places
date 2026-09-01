//
//  PlacesUITests.swift
//  PlacesUITests
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import XCTest

final class PlacesUITests: XCTestCase {

    private var app: XCUIApplication!
    private let testingID = UIIdentifiers.LocationListScreen.self
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments.append("--ui-testing")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    @MainActor
    func testLocationsScreenLoadsAndDisplaysList() throws {
        let locationsList = app.collectionViews[testingID.locationsList].firstMatch
        
        XCTAssertTrue(locationsList.waitForExistence(timeout: 5))
        
        XCTAssertGreaterThan(
            locationsList.cells.count,
            0,
            "Expected at least one location in the list"
        )
    }
}
