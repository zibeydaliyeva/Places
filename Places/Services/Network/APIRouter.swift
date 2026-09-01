//
//  APIRouter.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

enum APIRouter {
    
    private static let baseUrl = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main"
    
    case getLocations
    
    private var path: String {
        switch self {
        case .getLocations:
            return "/locations.json"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getLocations:
            return .get
        }
    }
    
    func request() throws -> URLRequest {
        let urlString = APIRouter.baseUrl + path
        
        guard let url = URL(string: urlString) else { throw NetworkError.incorrectUrl }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        request.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.httpMethod = method.rawValue
        return request
    }
    
}
