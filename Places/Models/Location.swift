//
//  Location.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

struct Location: Decodable, Identifiable {
    let name: String?
    let latitude: Double
    let longitude: Double

    /// Derived from content so the same JSON always decodes to the same identity,
    /// letting SwiftUI (List/ForEach) correctly recognize "unchanged" rows across re-fetches.
    var id: String { "\(name ?? "")|\(latitude)|\(longitude)" }

    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}
