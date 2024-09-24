//
//  LoadingFooter.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/20.
//

import UIKit

class LoadingFooter: UICollectionReusableView {
    static let reuseId = "LoadingFooter"
    let indicatorView = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(indicatorView)
        indicatorView.color = UIColor.label
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        indicatorView.startAnimating()
    }
}

#Preview {
    let cell = LoadingFooter()
    return cell
}
