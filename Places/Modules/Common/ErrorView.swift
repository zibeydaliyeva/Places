//
//  ErrorView.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import SwiftUI

struct ErrorView: View {
    let errorDescription: String
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack {
            titleView
            descriptionView
            retryButtonView
        } .padding(.horizontal)
    }
    
    var titleView: some View {
        Text("error_occurred".localized())
            .font(.title)
            .padding(.bottom)
    }
    
    var descriptionView: some View {
        Text(errorDescription)
            .font(.callout)
            .padding(.bottom)
            .multilineTextAlignment(.center)
    }
    
    var retryButtonView: some View {
        Button("retry".localized()) {
            retryAction?()
        }
        .frame(maxWidth: .infinity)
        .padding(PlacesUI.spacing.md)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(PlacesUI.radiuses.medium)
        .accessibilityHint("retry_hint".localized())
        .accessibilityIdentifier(UIIdentifiers.Common.retryButton)
    }
}

