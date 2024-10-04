//
//  GFButton.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/12.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(color: UIColor, title: String, systemName: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemName: systemName)
    }

    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }

    final func set(color: UIColor, title: String, systemName: String) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title

        configuration?.image = UIImage(systemName: systemName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
}
