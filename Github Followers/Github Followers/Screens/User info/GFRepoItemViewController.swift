//
//  GFRepoItemViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/25.
//

import UIKit

protocol RepoItemVCDelegate: AnyObject {
    func didTapGithubProfile(for user: User) -> Void
}

class GFRepoItemViewController: GFItemInfoViewController {
    unowned var delegate: RepoItemVCDelegate!

    init(user: User, delegate: RepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        leadingInfoView.set(for: .repos, with: user.publicRepos)
        trailingInfoView.set(for: .gists, with: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Github Profile", systemName: "person")
    }

    override func actionButtonTapped() {
        delegate.didTapGithubProfile(for: user)
    }
}
