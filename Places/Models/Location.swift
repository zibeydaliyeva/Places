//
//  Location.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

struct Location: Decodable, Identifiable {
    let id = UUID()
    let name: String?
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}

