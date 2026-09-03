//
//  UIIdentifiers.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

enum UIIdentifiers {
    
    enum Common {
        static let retryButton = "Common.retryButton"
    }
    
    enum LocationListScreen {
        static let locationsList = "LocationListScreen.locationList"
        static let searchButton = "LocationListScreen.searchButton"
        
        static func item(_ id: UUID) -> String {
            "LocationListScreen.locationItem.\(id.uuidString)"
        }
    }
    
    enum SearchLocationScreen {
        static let searchButton = "SearchLocationScreen.searchButton"
        static let nameField = "SearchLocationScreen.nameField"
        static let longitudeField = "SearchLocationScreen.longitudeField"
        static let latitudeField = "SearchLocationScreen.latitudeField"
        static let errorMessage = "SearchLocationScreen.errorMessage"
    }
}
