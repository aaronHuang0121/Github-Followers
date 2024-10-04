//
//  FavoritesListViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/12.
//

import UIKit

class FavoritesListViewController: UIViewController {
    let tableView = UITableView()
    var favorites: [Favorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configreViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    private func configreViewController() {
        view.backgroundColor = .systemBlue
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }

    private func getFavorites() {
        FavoriteFollowersService.shared.getFavorites { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    showEmptyState(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
                } else {
                    self.favorites = favorites.compactMap({ favorite in
                        guard let login = favorite.login, let avatarImage = favorite.avatarUrl else {
                            return nil
                        }
                        return .init(login: login, avatarImage: avatarImage)
                    })
                    self.tableView.reloadDataOnMainThread()
                }
            case .failure(let error):
                self.alert(title: "Something went wrong.", message: error.localizedDescription)
            }
        }
    }
}

extension FavoritesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId, for: indexPath)

        if let cell = cell as? FavoriteCell {
            let favorite = favorites[indexPath.row]
            cell.set(login: favorite.login, avatarImage: favorite.avatarImage)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListViewController(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard case .delete = editingStyle else { return }

        let favorite = favorites[indexPath.row]
        
        FavoriteFollowersService.shared.updateFavorite(favorite) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                favorites.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            case .failure(let error):
                self.alert(title: "Uable to remove", message: error.localizedDescription)
            }
        }
    }
    
}
