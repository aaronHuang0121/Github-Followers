//
//  UserTests.swift
//  Github FollowersTests
//
//  Created by Aaron on 2024/9/24.
//

import XCTest

@testable import Github_Followers

final class UserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_decodeJson_user_shouldSucceed() throws {
        let mock = User.mock
        let jsonData = """
            {
                  "login": "octocat",
                  "id": 1,
                  "node_id": "MDQ6VXNlcjE=",
                  "avatar_url": "https://github.com/images/error/octocat_happy.gif",
                  "gravatar_id": "",
                  "url": "https://api.github.com/users/octocat",
                  "html_url": "https://github.com/octocat",
                  "followers_url": "https://api.github.com/users/octocat/followers",
                  "following_url": "https://api.github.com/users/octocat/following{/other_user}",
                  "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
                  "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
                  "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
                  "organizations_url": "https://api.github.com/users/octocat/orgs",
                  "repos_url": "https://api.github.com/users/octocat/repos",
                  "events_url": "https://api.github.com/users/octocat/events{/privacy}",
                  "received_events_url": "https://api.github.com/users/octocat/received_events",
                  "type": "User",
                  "site_admin": false,
                  "name": "monalisa octocat",
                  "company": "GitHub",
                  "blog": "https://github.com/blog",
                  "location": "San Francisco",
                  "email": "octocat@github.com",
                  "hireable": false,
                  "bio": "There once was...",
                  "twitter_username": "monatheoctocat",
                  "public_repos": 2,
                  "public_gists": 1,
                  "followers": 20,
                  "following": 0,
                  "created_at": "2008-01-14T04:33:35Z",
                  "updated_at": "2008-01-14T04:33:35Z"
            }
        """
            .data(using: .utf8)!
        
        let decoded = try JSONDecoder.default.decode(User.self, from: jsonData)
        XCTAssertEqual(mock, decoded)
    }

    func test_encodeJson_user_shouldSucceed() throws {
        let mock = User.mock
        let jsonData = try JSONEncoder.default.encode(mock)
        let decoded = try JSONDecoder.default.decode(User.self, from: jsonData)
        
        XCTAssertEqual(mock, decoded)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
