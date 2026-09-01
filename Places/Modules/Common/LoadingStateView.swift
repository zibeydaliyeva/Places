//
//  LoadingStateView.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import SwiftUI

struct LoadingStateView<Value, Content: View>: View {
    
    let loadingState: LoadingState<Value>
    let content: (Value) -> Content
    let retryAction: (() -> Void)?
    
    var body: some View {
        switch loadingState {
        case .idle:
            Color.clear
        case .loading:
            ProgressView()
        case .loaded(let value):
            content(value)
        case .failed(let errorDescription):
            ErrorView(errorDescription: errorDescription, retryAction: retryAction)
            
        }
    }
}
