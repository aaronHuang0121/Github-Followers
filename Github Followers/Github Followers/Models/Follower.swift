//
//  Follower.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/13.
//

import Foundation

struct Follower: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let nodeId: String
    let login: String
    let name: String?
    let email: String?
    let avatarUrl: String
    let gravatarId: String?
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let organizationsUrl: String
    let type: FollowerType
    let siteAdmin: Bool
    let starredAt: Date?
}

extension Follower {
    enum FollowerType: String, Codable, Equatable, Hashable {
        case user = "User"
    }
}

extension Follower {
    static let mock = Follower(
        id: 1060,
        nodeId: "MDQ6VXNlcjEwNjA=",
        login: "andrew",
        name: nil,
        email: nil,
        avatarUrl: "https://avatars.githubusercontent.com/u/1060?v=4",
        gravatarId: "",
        url: "https://api.github.com/users/andrew",
        htmlUrl: "https://github.com/andrew",
        followersUrl: "https://api.github.com/users/andrew/followers",
        followingUrl: "https://api.github.com/users/andrew/following{/other_user}",
        gistsUrl: "https://api.github.com/users/andrew/gists{/gist_id}",
        starredUrl: "https://api.github.com/users/andrew/starred{/owner}{/repo}",
        subscriptionsUrl: "https://api.github.com/users/andrew/subscriptions",
        reposUrl: "https://api.github.com/users/andrew/repos",
        eventsUrl: "https://api.github.com/users/andrew/events{/privacy}",
        receivedEventsUrl: "https://api.github.com/users/andrew/received_events",
        organizationsUrl: "https://api.github.com/users/andrew/orgs",
        type: .user,
        siteAdmin: false,
        starredAt: nil
    )
}
