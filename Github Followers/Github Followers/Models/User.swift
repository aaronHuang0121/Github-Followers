//
//  User.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/24.
//

import Foundation

struct User: Codable, Identifiable, Equatable, Hashable {
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: String
    let gravatarId: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: Follower.FollowerType
    let siteAdmin: Bool
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let notificationEmail: String?
    let hireable: Bool?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: Date
    let updatedAt: Date
}

extension User {
    func toFavorite() -> Favorite {
        return Favorite(login: login, avatarImage: avatarUrl)
    }
}

extension User {
    static let mock = User(
        login: "octocat",
        id: 1,
        nodeId: "MDQ6VXNlcjE=",
        avatarUrl: "https://github.com/images/error/octocat_happy.gif",
        gravatarId: "",
        url: "https://api.github.com/users/octocat",
        htmlUrl: "https://github.com/octocat",
        followersUrl: "https://api.github.com/users/octocat/followers",
        followingUrl: "https://api.github.com/users/octocat/following{/other_user}",
        gistsUrl: "https://api.github.com/users/octocat/gists{/gist_id}",
        starredUrl: "https://api.github.com/users/octocat/starred{/owner}{/repo}",
        subscriptionsUrl: "https://api.github.com/users/octocat/subscriptions",
        organizationsUrl: "https://api.github.com/users/octocat/orgs",
        reposUrl: "https://api.github.com/users/octocat/repos",
        eventsUrl: "https://api.github.com/users/octocat/events{/privacy}",
        receivedEventsUrl: "https://api.github.com/users/octocat/received_events",
        type: .user,
        siteAdmin: false,
        name: "monalisa octocat",
        company: "GitHub",
        blog: "https://github.com/blog",
        location: "San Francisco",
        email: "octocat@github.com", 
        notificationEmail: nil,
        hireable: false,
        bio: "There once was...",
        twitterUsername: "monatheoctocat",
        publicRepos: 2,
        publicGists: 1,
        followers: 20,
        following: 0,
        createdAt: Date(timeIntervalSinceReferenceDate: 221978015),
        updatedAt: Date(timeIntervalSinceReferenceDate: 221978015)
    )
}
