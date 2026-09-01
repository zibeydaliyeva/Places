//
//  APIService.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

protocol APIServiceProtocol {
    func getLocations() async throws -> LocationsResponse
}


final class APIService: APIServiceProtocol {
    private var urlSession: URLSession
    
    // MARK: - Initializer
    init(with urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getLocations() async throws -> LocationsResponse {
        try await self.request(router: .getLocations)
    }
}


extension APIService {
    
    private func request<T: Decodable>(router: APIRouter) async throws -> T {
        do {
            let (data, response) = try await urlSession.data(for: router.request())
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.emptyResponseError
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.serverError
            }
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch _ as URLError {
            throw NetworkError.connectionError
        } catch _ as DecodingError {
            throw NetworkError.parseError
        }
    }
}

