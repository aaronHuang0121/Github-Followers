//
//  FollowerCell.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/14.
//

import UIKit
import SwiftUI

class FollowerCell: UICollectionViewCell {
    static let reuseId = "FollowerCell"
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 16.0, *) {
            
        } else {
            configure()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(follower: Follower) {
        if #available(iOS 16.0, *) {
            contentConfiguration = UIHostingConfiguration {
                FollowerView(follower: follower)
            }
        } else {
            usernameLabel.text = follower.login
            avatarImageView.downloadImage(from: follower.avatarUrl)
        }
    }
    
    private func configure() {
        let padding: CGFloat = 8
        addSubviews(avatarImageView, usernameLabel)
        configureImage(padding: padding)
        configureUsernameLabel(padding: padding)
    }

    private func configureImage(padding: CGFloat) {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
    }

    private func configureUsernameLabel(padding: CGFloat) {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
