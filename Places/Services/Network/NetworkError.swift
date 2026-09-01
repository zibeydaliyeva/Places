//
//  NetworkError.swift
//  Places
//
//  Created by Zibeyda Aliyeva on 01/09/2026.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    
    case parseError,
         emptyResponseError,
         incorrectUrl,
         connectionError,
         serverError,
         defaultError(String)
    
    
    var errorDescription: String? {
        switch self {
        case .parseError:
            return "parse_error".localized()
        case .emptyResponseError:
            return "empty_response".localized()
        case .serverError:
            return "server_error".localized()
        case .incorrectUrl:
            return "incorrect_url".localized()
        case .connectionError:
            return "internet_offline".localized()
        case .defaultError(let errorMessage):
            return errorMessage
        }
    }
}

