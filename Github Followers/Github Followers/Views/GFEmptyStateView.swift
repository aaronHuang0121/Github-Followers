//
//  GFEmptyStateView.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/24.
//

import UIKit

class GFEmptyStateView: UIView {
    private let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    private let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }

    private func configure() {
        addSubviews(messageLabel, logoImageView)
        
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        logoImageView.image = UIImage(named: "empty-state")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit

        let labelCenterConstant: CGFloat = UIWindow.current?.screen.bounds.height ?? 0 > 700 ? -200 : -130
        let logoBottomConstraint: CGFloat = UIWindow.current?.screen.bounds.height ?? 0 > 700 ? 300 : 200
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterConstant),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),

            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 200),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomConstraint)
        ])
    }
}

#Preview {
    return GFEmptyStateView(message: "This user don't have followers.")
}
