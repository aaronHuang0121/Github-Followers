//
//  UserInfoViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/24.
//

import UIKit

class UserInfoViewController: UIViewController {
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        NetworkManager.shared.getUser(username: username) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                dump(user)
            case .failure(let error):
                self.alert(title: "Something went wrong.", message: error.localizedDescription)
            }
        }
    }

    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
