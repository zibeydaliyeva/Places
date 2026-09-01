//
//  RoundedBorderTextFieldStyle.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import SwiftUI

struct RoundedBorderTextFieldStyle: TextFieldStyle {
    private var isInvalid: Bool
    private let keyboardType: UIKeyboardType

    init(isInvalid: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.isInvalid = isInvalid
        self.keyboardType = keyboardType
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .keyboardType(keyboardType)
            .padding(PlacesUI.spacing.xs)
            .overlay(
                RoundedRectangle(cornerRadius: PlacesUI.radiuses.small)
                    .stroke(isInvalid ? Color.red : Color.gray, lineWidth: 1)
            )
    }
}
