//
//  SearchLocationViewUITests.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import XCTest

final class SearchLocationViewUITests: XCTestCase {

    private var app: XCUIApplication!
    private let testingID = UIIdentifiers.SearchLocationScreen.self
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--ui-testing")
        app.launch()
        openSearchLocationSheet()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    private func openSearchLocationSheet() {
        let searchViewButton = app.buttons[UIIdentifiers.LocationListScreen.searchButton]
        
        searchViewButton.tap()
    }
    
    private func assertTextFieldIsCleared(
        _ textField: XCUIElement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let value = textField.value as? String ?? ""
        let placeholder = textField.placeholderValue ?? ""

        XCTAssertTrue(
            value.isEmpty || value == placeholder,
            "Expected text field to be cleared, but value was '\(value)'",
            file: file,
            line: line
        )
    }
    
    func testSearchByName() throws {
        let latitudeField = app.textFields[testingID.latitudeField]
        let longitudeField = app.textFields[testingID.longitudeField]
        let nameField = app.textFields[testingID.nameField]
        
        
        XCTAssertTrue(latitudeField.exists)
        XCTAssertTrue(longitudeField.exists)
        XCTAssertTrue(nameField.exists)
        
        latitudeField.tap()
        latitudeField.typeText("40.5")
        
        longitudeField.tap()
        longitudeField.typeText("40.5")
        
        nameField.tap()
        nameField.typeText("New York")
        
  
        // Entering a location name should clear coordinate input.
        let latitudeCleared = NSPredicate(format: "value == '' OR value == %@", latitudeField.placeholderValue ?? "")
        let longitudeCleared = NSPredicate(format: "value == '' OR value == %@", longitudeField.placeholderValue ?? "")
        
        expectation( for: latitudeCleared, evaluatedWith: latitudeField)
        expectation( for: longitudeCleared, evaluatedWith: longitudeField )
        
        waitForExpectations(timeout: 5)
        
        assertTextFieldIsCleared(latitudeField)
        assertTextFieldIsCleared(longitudeField)
        
        let searchButton = app.buttons[testingID.searchButton]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()

        // Confirm sheet dismissed
        XCTAssertFalse(searchButton.waitForExistence(timeout: 5))
    }
    
    // MARK: - Test typing coordinates
      func testSearchByCoordinates() throws {

          let latField = app.textFields[testingID.latitudeField]
          let longField = app.textFields[testingID.longitudeField]

          XCTAssertTrue(latField.waitForExistence(timeout: 5))
          XCTAssertTrue(longField.waitForExistence(timeout: 5))

          latField.tap()
          latField.typeText("40.7128")

          longField.tap()
          longField.typeText("-74.0060")

          let searchButton = app.buttons[testingID.searchButton]
          searchButton.tap()

          XCTAssertFalse(searchButton.waitForExistence(timeout: 5))
      }
    
    // MARK: - Test error handling
    func testErrorMessageAppearsForInvalidCoordinates() throws {
        let latField = app.textFields[testingID.latitudeField]
        let longField = app.textFields[testingID.longitudeField]

        latField.tap()
        latField.typeText("invalid_lat")

        longField.tap()
        longField.typeText("invalid_long")

        let searchButton = app.buttons[testingID.searchButton]
        searchButton.tap()
        
        // Example: ViewModel shows error text
      
        let errorText = app.staticTexts[testingID.errorMessage]
        XCTAssertTrue(errorText.waitForExistence(timeout: 5))
    }
}
