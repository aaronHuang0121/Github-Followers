//
//  FollowerListViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/12.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String) -> Void
}

class FollowerListViewController: UIViewController {
    var username: String!

    private(set) var user: User?
    var fetchedFollowers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var isLoading: Bool = true
    var isSearching: Bool = false
    private let perPage: Int = 20

    private var followers: [Follower] {
        isSearching ? filteredFollowers : fetchedFollowers
    }
    
    var collectionView: UICollectionView!

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        self.title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .systemGreen
        
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        configureAddNavigationRightItem()
    }

    private func configureAddNavigationRightItem() {
        let contained = FavoriteFollowersService.shared.contains(with: username)
        let addButton = UIBarButtonItem(barButtonSystemItem: contained ? .trash : .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func configureLoadingNavigationRightItem() {
        let indicator = UIActivityIndicatorView(frame: .init(x: 0, y: 0, width: 20, height: 20))
        let loadingButton = UIBarButtonItem(customView: indicator)
        navigationItem.rightBarButtonItem = loadingButton
        indicator.startAnimating()
    }

    private func configureSuccessNavigationRightItem() {
        let success = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        success.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: success)
    }
    
    private func configureCollectionView() {
        self.collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.createColumnsFlowLayout(in: view, columns: 3)
        )
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
        collectionView.register(
            LoadingFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooter.reuseId
        )
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for an username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String, page: Int) {
        isLoading = true
        collectionView.reloadData()
    
        NetworkManager.shared.getFollowers(username: username, page: page, perPage: perPage) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let followers):
                if followers.count < self.perPage { self.hasMoreFollowers = false }
                self.fetchedFollowers.append(contentsOf: followers)
                if self.fetchedFollowers.isEmpty {
                    DispatchQueue.main.async {
                        self.showEmptyState(with: "This user doesn't have any followers.", in: self.view)
                    }
                }
            case .failure(let error):
                self.alert(
                    title: "Bad stuff happened",
                    message: error.localizedDescription
                )
            }
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    @objc func addButtonTapped() {
        configureLoadingNavigationRightItem()
        let group = DispatchGroup()
        if user?.login != username {
            group.enter()
            NetworkManager.shared.getUser(username: username) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let user):
                    self.user = user
                    self.username = user.login
                case .failure(let error):
                    self.alert(title: "Something went wrong.", message: error.localizedDescription)
                    self.configureAddNavigationRightItem()
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }

            guard let user = self.user?.toFavorite() else {
                self.alert(title: "Something went wrong.", message: "There are missing user. Please try again.")
                return
            }
            
            FavoriteFollowersService.shared.updateFavorite(user) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success:
                    DispatchQueue.main.async { self.updateFavoriteSuccess() }
                case .failure(let error):
                    self.alert(title: "Something went wrong.", message: error.localizedDescription)
                    self.configureAddNavigationRightItem()
                }
            }
        }
    }

    private func updateFavoriteSuccess() {
        UIView.animate(options: .curveEaseInOut) {
            self.configureSuccessNavigationRightItem()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.configureAddNavigationRightItem()
            }
        }
    }
}

extension FollowerListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FollowerCell.reuseId,
            for: indexPath
        )
        if let cell = cell as? FollowerCell {
            cell.set(follower: followers[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: LoadingFooter.reuseId,
                for: indexPath
            )
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoading ? .init(width: collectionView.frame.width, height: 50) : .zero
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard hasMoreFollowers, !isLoading, !isSearching else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = followers[indexPath.item]
        let userInfoViewController = UserInfoViewController()
        userInfoViewController.username = follower.login
        userInfoViewController.delegate = self
        let navController = UINavigationController(rootViewController: userInfoViewController)
        present(navController, animated: true)
    }
}

extension FollowerListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            isSearching = false
            collectionView.reloadData()
            return
        }

        isSearching = true
        
        filteredFollowers = fetchedFollowers.filter({ follower in
            follower.login.lowercased().contains(filter.lowercased())
        })

        collectionView.reloadData()
    }
}

extension FollowerListViewController: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        self.title = username
        fetchedFollowers.removeAll()
        filteredFollowers.removeAll()
        page = 1

        collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: 1)
    }
}

extension FollowerListViewController {
    enum Section {
        case main
    }
}
