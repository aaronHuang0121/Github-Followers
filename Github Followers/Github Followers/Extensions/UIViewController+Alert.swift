//
//  UIViewController+Alert.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/13.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(title: String, message: String, buttonTitle: String = "OK")  {
        DispatchQueue.main.async { [weak self] in
            let alertVC = AlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self?.present(alertVC, animated: true)
        }
    }
}
