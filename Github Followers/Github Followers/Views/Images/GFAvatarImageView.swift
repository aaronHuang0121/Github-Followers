//
//  GFAvatarImageView.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/14.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeholderImage = UIImage(named: "avatar-placeholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFit
        image = placeholderImage
    }

    func downloadImage(from urlString: String) -> Void {
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] image in
            guard let self, let image else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
