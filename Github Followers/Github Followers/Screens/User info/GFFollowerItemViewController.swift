//
//  GFFollowerItemViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/25.
//

import Foundation

protocol FollowersItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User) -> Void
}

class GFFollowerItemViewController: GFItemInfoViewController {
    unowned var delegate: FollowersItemVCDelegate!

    init(user: User, delegate: FollowersItemVCDelegate) {
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
        leadingInfoView.set(for: .followers, with: user.followers)
        trailingInfoView.set(for: .following, with: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers", systemName: "person.3")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
