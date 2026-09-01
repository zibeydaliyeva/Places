//
//  CoordinateAxis.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

enum CoordinateAxis {
    case latitude
    case longitude

    private var range: ClosedRange<Double> {
        switch self {
        case .latitude:  -90...90
        case .longitude: -180...180
        }
    }

    func value(from text: String) -> Double? {
        let normalized = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        guard let value = Double(normalized),
              range.contains(value) else {
            return nil
        }
        return value
    }
    
    func isInvalid( from text: String) -> Bool {
        guard !text.isEmpty else { return false }
        return value(from: text) == nil
    }
}
