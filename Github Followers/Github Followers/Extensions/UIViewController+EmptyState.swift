//
//  UIViewController+EmptyState.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/24.
//

import UIKit

extension UIViewController {
    func showEmptyState(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
