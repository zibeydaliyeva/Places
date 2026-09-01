//
//  CoordinateAxisTest.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Testing
@testable import Places

struct CoordinateAxisTest {

    // MARK: - value(from:) — valid parsing
    @Test(arguments: [
        ("0", 0.0),
        ("45.5", 45.5),
        ("-45.5", -45.5),
        ("90", 90.0),
        ("-90", -90.0),
        (" 45.5 ", 45.5),
        ("45,5", 45.5),
    ])
    
    func latitudeValueParsesValidInput(text: String, expected: Double) {
        let result = CoordinateAxis.latitude.value(from: text)
        #expect(result == expected)
    }

    @Test(arguments: [
        ("0", 0.0),
        ("120.25", 120.25),
        ("-120.25", -120.25),
        ("180", 180.0),
        ("-180", -180.0),
        (" 120.25 ", 120.25),
        ("120,25", 120.25),
    ])
    
    func longitudeValueParsesValidInput(text: String, expected: Double) {
        let result = CoordinateAxis.longitude.value(from: text)
        #expect(result == expected)
    }

    // MARK: - value(from:) — out of range

    @Test(arguments: ["90.1", "-90.1", "91", "-91", "1000"])
    func latitudeValueReturnsNilWhenOutOfRange(text: String) {
        #expect(CoordinateAxis.latitude.value(from: text) == nil)
    }

    @Test(arguments: ["180.1", "-180.1", "181", "-181", "1000"])
    func longitudeValueReturnsNilWhenOutOfRange(text: String) {
        #expect(CoordinateAxis.longitude.value(from: text) == nil)
    }

    // MARK: - value(from:) — unparsable input

    @Test(arguments: ["", "abc", "45.5.5", "--45", "45,5,5", "   "])
    func valueReturnsNilForUnparsableInput(text: String) {
        #expect(CoordinateAxis.latitude.value(from: text) == nil)
        #expect(CoordinateAxis.longitude.value(from: text) == nil)
    }

    // MARK: - isInvalid(from:)
    @Test func isInvalidReturnsFalseForEmptyString() {
        #expect(CoordinateAxis.latitude.isInvalid(from: "") == false)
        #expect(CoordinateAxis.longitude.isInvalid(from: "") == false)
    }

    @Test(arguments: ["45.5", "-90", "90", " 45,5 "])
    func isInvalidReturnsFalseForValidLatitude(text: String) {
        #expect(CoordinateAxis.latitude.isInvalid(from: text) == false)
    }

    @Test(arguments: ["91", "-91", "abc", "1000"])
    func isInvalidReturnsTrueForInvalidLatitude(text: String) {
        #expect(CoordinateAxis.latitude.isInvalid(from: text) == true)
    }

    @Test(arguments: ["120.5", "-180", "180", " 120,5 "])
    func isInvalidReturnsFalseForValidLongitude(text: String) {
        #expect(CoordinateAxis.longitude.isInvalid(from: text) == false)
    }

    @Test(arguments: ["181", "-181", "abc", "1000"])
    func isInvalidReturnsTrueForInvalidLongitude(text: String) {
        #expect(CoordinateAxis.longitude.isInvalid(from: text) == true)
    }
}
