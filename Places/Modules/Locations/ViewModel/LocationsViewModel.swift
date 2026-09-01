//
//  LocationsViewModel.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation
import Observation

@Observable
final class LocationsViewModel {
    private(set) var state: LoadingState<LocationsResponse> = .idle
    private let service: APIServiceProtocol
    private(set) var deepLink: DeepLinkServiceProtocol
    
    init(service: APIServiceProtocol, deepLink: DeepLinkServiceProtocol) {
        self.service = service
        self.deepLink = deepLink
    }
    
    func fetchLocations() async {
        guard !state.isLoading else { return}
        state = .loading
        
        do {
            let data = try await service.getLocations()
            state = .loaded(data)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    func appURL(for location: Location) -> URL? {
        return deepLink.createAppURL(for: location)
    }
    
    func webURL(for location: Location) -> URL? {
        return deepLink.createWebURL(for: location)
    }
}
