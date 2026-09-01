//
//  PlacesApp.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import SwiftUI

@main
struct PlacesApp: App {
    var body: some Scene {
        WindowGroup {
            LocationsListView(
                viewModel: LocationsViewModel(
                    service: APIService(),
                    deepLink: DeepLinkService()
                )
            )
        }
    }
}
