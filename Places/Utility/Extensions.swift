//
//  Extensions.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

extension String {
    /// Returns a localized string without arguments
    func localized() -> String {
        self.localized(arguments: [])
    }
    
    /// Returns a localized string formatted with arguments
    func localized(arguments: any CVarArg...) -> String {
        String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

