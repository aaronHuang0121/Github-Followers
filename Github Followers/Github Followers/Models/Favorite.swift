//
//  Favorite.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/26.
//

import Foundation

struct Favorite: Identifiable, Equatable {
    let login: String
    let avatarImage: String
    
    var id: String { login }
}
