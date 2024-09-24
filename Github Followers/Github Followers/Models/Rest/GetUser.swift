//
//  GetUser.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/24.
//

import Foundation

extension Rest {
    enum GetUser {
        typealias Response = User
    }
}

extension RestClient {
    func getUser(
        username: String,
        completion: @escaping (Result<Rest.GetUser.Response, RestError>) -> Void
    ) {
        get(endpoint: "/users/\(username)", completion: completion)
    }
}
