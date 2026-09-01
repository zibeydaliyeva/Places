//
//  NetworkingEnums.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
}


enum ContentType: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}
