//
//  FollowerTests.swift
//  Github FollowersTests
//
//  Created by Aaron on 2024/9/13.
//

import XCTest

@testable import Github_Followers

final class FollowerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_decodeJson_follower_shouldSucceed() throws {
        let mock = Follower.mock
        let jsonData = """
            {
                "login": "andrew",
                "id": 1060,
                "node_id": "MDQ6VXNlcjEwNjA=",
                "avatar_url": "https://avatars.githubusercontent.com/u/1060?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/andrew",
                "html_url": "https://github.com/andrew",
                "followers_url": "https://api.github.com/users/andrew/followers",
                "following_url": "https://api.github.com/users/andrew/following{/other_user}",
                "gists_url": "https://api.github.com/users/andrew/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/andrew/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/andrew/subscriptions",
                "organizations_url": "https://api.github.com/users/andrew/orgs",
                "repos_url": "https://api.github.com/users/andrew/repos",
                "events_url": "https://api.github.com/users/andrew/events{/privacy}",
                "received_events_url": "https://api.github.com/users/andrew/received_events",
                "type": "User",
                "site_admin": false
              }
        """
            .data(using: .utf8)!

        let decoded = try JSONDecoder.default.decode(Follower.self, from: jsonData)
        
        XCTAssertEqual(mock, decoded)
    }

    func test_encodeJson_follower_shouldSucceed() throws {
        let mock = Follower.mock
        let jsonData = try JSONEncoder.default.encode(mock)
        let decoded = try JSONDecoder.default.decode(Follower.self, from: jsonData)
        
        XCTAssertEqual(mock, decoded)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
