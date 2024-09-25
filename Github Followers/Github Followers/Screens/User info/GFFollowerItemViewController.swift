//
//  GFFollowerItemViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/25.
//

import Foundation

class GFFollowerItemViewController: GFItemInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    private func configureItems() {
        leadingInfoView.set(for: .followers, with: user.followers)
        trailingInfoView.set(for: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
