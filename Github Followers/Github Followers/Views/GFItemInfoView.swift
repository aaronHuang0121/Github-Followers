//
//  GFItemInfoView.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/25.
//

import UIKit

class GFItemInfoView: UIView {
    let symbleImageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubviews(symbleImageView, titleLabel, countLabel)

        symbleImageView.translatesAutoresizingMaskIntoConstraints = false
        symbleImageView.contentMode = .scaleAspectFill
        symbleImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbleImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbleImageView.widthAnchor.constraint(equalToConstant: 20),
            symbleImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.centerYAnchor.constraint(equalTo: symbleImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbleImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbleImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func set(for type: Types, with count: Int) {
        symbleImageView.image = type.symbolImage
        titleLabel.text = type.title
        countLabel.text = "\(count)"
    }
}

extension GFItemInfoView {
    enum Types {
        case repos
        case gists
        case followers
        case following

        var symbolImage: UIImage? {
            switch self {
            case .repos:
                return UIImage(systemName: "folder")
            case .gists:
                return UIImage(systemName: "text.alignleft")
            case .followers:
                return UIImage(systemName: "heart")
            case .following:
                return UIImage(systemName: "person.2")
            }
        }

        var title: String {
            switch self {
            case .repos:
                return "Public Repos"
            case .gists:
                return "Public Gists"
            case .followers:
                return "Followers"
            case .following:
                return "Following"
            }
        }
        
    }
}
