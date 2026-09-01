//
//  APIServiceErrorMappingTest.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Testing
@testable import Places
internal import Foundation

@MainActor
struct APIServiceErrorMappingTest {
    
    private func makeSUT() -> APIService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return APIService(with: URLSession(configuration: configuration))
    }
    
    @Test func networkErrorMapping() async {
        StubURLProtocol.stubResponder = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: "HTTP/1.1", headerFields: nil)!
            return (response, Data(), nil)
        }
        do {
            _ = try await makeSUT().getLocations()
            Issue.record("Expected NetworkError.serverError to be thrown")
        } catch let error as NetworkError {
            #expect(error == .serverError)
        } catch {
            Issue.record("Expected NetworkError, got \(error)")
        }
        
        // Malformed JSON body -> .parseError
        StubURLProtocol.stubResponder = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
            return (response, Data("not valid json".utf8), nil)
        }
        do {
            _ = try await makeSUT().getLocations()
            Issue.record("Expected NetworkError.parseError to be thrown")
        } catch let error as NetworkError {
            #expect(error == .parseError)
        } catch {
            Issue.record("Expected NetworkError, got \(error)")
        }
        
        // Underlying transport failure -> .connectionError
        StubURLProtocol.stubResponder = { _ in (nil, nil, URLError(.notConnectedToInternet)) }
        do {
            _ = try await makeSUT().getLocations()
            Issue.record("Expected NetworkError.connectionError to be thrown")
        } catch let error as NetworkError {
            #expect(error == .connectionError)
        } catch {
            Issue.record("Expected NetworkError, got \(error)")
        }
    }
}


/// Intercepts `URLSession` requests and returns a canned response/error, so `APIService`'s
/// error-mapping branches can be tested without real network access.
private final class StubURLProtocol: URLProtocol {
    static var stubResponder: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        let (response, data, error) = Self.stubResponder?(request) ?? (nil, nil, nil)
        
        if let error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
