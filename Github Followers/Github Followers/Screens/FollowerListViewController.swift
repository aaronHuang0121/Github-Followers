//
//  FollowerListViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/12.
//

import UIKit

class FollowerListViewController: UIViewController {
    var username: String!
    var followers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var isLoading: Bool = true
    private let perPage: Int = 20
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
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
        
        configureCollectionView()
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
    
    private func getFollowers(username: String, page: Int) {
        isLoading = true
        collectionView.reloadData()
    
        NetworkManager.shared.getFollowers(username: username, page: page, perPage: perPage) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let followers):
                if followers.count < self.perPage { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
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
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooter.reuseId, for: indexPath)
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoading ? .init(width: collectionView.frame.width, height: 50) : .zero
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard hasMoreFollowers else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height, !isLoading {
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}

extension FollowerListViewController {
    enum Section {
        case main
    }
}
