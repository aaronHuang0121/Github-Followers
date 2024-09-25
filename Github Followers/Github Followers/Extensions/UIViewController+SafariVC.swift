//
//  UIViewController+SafariVC.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/25.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentSafariVC(with url: URL) -> Void {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}
