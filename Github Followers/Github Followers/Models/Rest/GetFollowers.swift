//
//  GetFollowers.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/13.
//

import Foundation

extension Rest {
    enum GetFollowers {
        typealias Response = [Follower]
        
        struct Params: Encodable {
            let perPage: Int
            let page: Int
        }
    }
}

extension RestClient {
    func getFollowers(
        username: String,
        page: Int = 1,
        completion: @escaping (Result<Rest.GetFollowers.Response, RestError>) -> Void
    ) {
        get(
            endpoint: "/users/\(username)/followers",
            params: Rest.GetFollowers.Params(perPage: 100, page: page),
            completion: completion
        )
    }
}
