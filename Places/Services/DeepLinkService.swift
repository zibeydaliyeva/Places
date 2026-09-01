//
//  DeepLinkService.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

protocol DeepLinkServiceProtocol {
    var baseAppURL: String { get }
    var baseWebURL: String { get }
    func createAppURL(for location: Location) -> URL?
    func createWebURL(for location: Location) -> URL?
}

struct DeepLinkService: DeepLinkServiceProtocol, Sendable {
    let baseAppURL = "wikipedia://places"
    let baseWebURL = "https://en.wikipedia.org/wiki/"

    func createAppURL(for location: Location) -> URL? {
        var appComponents = URLComponents(string: baseAppURL)
        appComponents?.queryItems = [
            URLQueryItem(name: "lat", value: String(location.latitude)),
            URLQueryItem(name: "lon", value: String(location.longitude))
        ]
        return appComponents?.url
    }

    func createWebURL(for location: Location) -> URL? {
        guard let name = location.name else { return nil }
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        return URL(string: baseWebURL + encodedName)
    }
}
