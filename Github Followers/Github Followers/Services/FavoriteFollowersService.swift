//
//  FavoriteFollowersService.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/26.
//

import CoreData
import Foundation
import os

enum CoreDataService {
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "CoreData")
}

enum FavoriteError: LocalizedError {
    case unableToFavorite
    case alreadyInFavorites
    case failedToFetchFavorites

    var errorDescription: String? {
        switch self {
        case .unableToFavorite:
            return "There was an error favoriting this user. Please try again."
        case .alreadyInFavorites:
            return "Yon've already favorited this user. You must REALLY like them!"
        case .failedToFetchFavorites:
            return "Some things went wrong when getting favorites."
        }
    }
}

final class FavoriteFollowersService {
    static let shared = FavoriteFollowersService()

    private let container: NSPersistentContainer
    private let containerName = "FavoriteContainer"
    private let entityName = "FavoriteEntity"

    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                CoreDataService.logger.error("Error load Core Data: \(error.localizedDescription)")
                return
            }
        }
    }

    func updateFavorite(_ user: User, completion: (Result<[FavoriteEntity], FavoriteError>) -> Void) {
        getFavorites { result in
            switch result {
            case .success(let favorites):
                if let entity = favorites.first(where: { $0.login == user.login }) {
                    delete(entity, completion: completion)
                } else {
                    add(user, completion: completion)
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }

    func contains(with username: String) -> Bool {
        var userContains: Bool = false
        
        getFavorites { [weak self] result in
            guard self != nil else { return }

            switch result {
            case .success(let favorites):
                userContains = favorites.contains(where: { $0.login == username })
            case .failure:
                userContains = false
            }
        }
        
        return userContains
    }
}

extension FavoriteFollowersService {
    private func getFavorites(completion: (Result<[FavoriteEntity], FavoriteError>) -> Void) {
        let request = NSFetchRequest<FavoriteEntity>(entityName: self.entityName)
        
        do {
            let favorites = try container.viewContext.fetch(request)
            completion(.success(favorites))
        } catch let error {
            CoreDataService.logger.error("Error fetch favorites: \(error.localizedDescription)")
            completion(.failure(.failedToFetchFavorites))
        }
    }

    private func add(_ user: User, completion: (Result<[FavoriteEntity], FavoriteError>) -> Void) {
        let entity = FavoriteEntity(context: container.viewContext)
        entity.login = user.login
        entity.avatarUrl = user.avatarUrl
        
        applyChanges(completion: completion)
    }

    private func delete(_ entity: FavoriteEntity, completion: (Result<[FavoriteEntity], FavoriteError>) -> Void) {
        container.viewContext.delete(entity)
        
        applyChanges(completion: completion)
    }

    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            CoreDataService.logger.error("Error save core data: \(error.localizedDescription)")
        }
    }

    private func applyChanges(completion: (Result<[FavoriteEntity], FavoriteError>) -> Void) {
        save()
        getFavorites(completion: completion)
    }
}
