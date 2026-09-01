//
//  PlacesUI.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

final class PlacesUI {
    /// Spacing used for distance
   static let spacing: PlacesUI.Spacing = Spacing()
    
    /// Radius  used for corners
   static let radiuses: PlacesUI.Radius = Radius()
}

extension PlacesUI {
    struct Spacing {
        /// Equals to 4 points
        var xxs: CGFloat = 4

        /// Equals to 8 points
        var xs: CGFloat = 8

        /// Equals to 12 points
        var sm: CGFloat = 12

        /// Equals to 16 points
        var md: CGFloat = 16

        /// Equals to 20 points
        var lg: CGFloat = 20

        /// Equals to 24 points
        var xl: CGFloat = 24
        
        /// Equals to 28 points
        var xxl: CGFloat = 28
    }
}


extension PlacesUI {
    
    /// Radius tokens used for corners
    struct Radius {
        /// Equals to 0 points
        var none: CGFloat = 0

        /// Equals to 8 points
        var small: CGFloat = 8

        /// Equals to 12 points
        var medium: CGFloat = 12

        /// Equals to 20 points
        var large: CGFloat = 20
    }
}
