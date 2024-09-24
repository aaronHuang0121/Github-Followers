//
//  RestClient.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/13.
//

import Foundation
import os

enum Rest {
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Rest")
    static let baseURL = "https://api.github.com"
}

enum RestError: LocalizedError {
    case invalidURL(String)
    case unableToComplete
    case invalidResponse(Int)
    case invalidData
    case unknowError(any Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid Url: \(url)"
        case .unableToComplete:
            return "Unable to complete"
        case .invalidResponse(let statusCode):
            return "Invalid response with error code: \(statusCode)"
        case .invalidData:
            return "Invalid data"
        case .unknowError(let error):
            return error.localizedDescription
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
}

protocol RestClient {
    func get<R: Decodable, P: Encodable>(
        endpoint: String,
        params: P?,
        completion: @escaping (Result<R, RestError>) -> Void
    )

    func get<R: Decodable>(
        endpoint: String,
        completion: @escaping(Result<R, RestError>) -> Void
    )
}
