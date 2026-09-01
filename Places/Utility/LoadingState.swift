//
//  LoadingState.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

enum LoadingState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}

extension LoadingState {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}
