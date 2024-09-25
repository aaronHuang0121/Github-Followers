//
//  GFRepoItemViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/25.
//

import UIKit

class GFRepoItemViewController: GFItemInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        leadingInfoView.set(for: .repos, with: user.publicRepos)
        trailingInfoView.set(for: .gists, with: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }

    override func actionButtonTapped() {
        delegate.didTapGithubProfile(for: user)
    }
}
