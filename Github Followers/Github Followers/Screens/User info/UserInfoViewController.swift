//
//  UserInfoViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/24.
//

import UIKit

class UserInfoViewController: UIViewController {
    var username: String!

    let headerView = UIView()
    let firstItemView = UIView()
    let secondItemView = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureViewController()
        getUserInfo()
    }

    @objc func dismissViewController() {
        dismiss(animated: true)
    }

    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }

    func getUserInfo() {
        NetworkManager.shared.getUser(username: username) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderViewController(user: user), to: self.headerView)
                    self.add(childVC: GFRepoItemViewController(user: user), to: self.firstItemView)
                    self.add(childVC: GFFollowerItemViewController(user: user), to: self.secondItemView)
                    self.dateLabel.text = "Github since \(user.createdAt.formatted())"
                }
            case .failure(let error):
                self.alert(title: "Something went wrong.", message: error.localizedDescription)
            }
        }
    }
    
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        let subViews = [headerView, firstItemView, secondItemView, dateLabel]
        for subView in subViews {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                subView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            firstItemView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            firstItemView.heightAnchor.constraint(equalToConstant: itemHeight),
            
            secondItemView.topAnchor.constraint(equalTo: firstItemView.bottomAnchor, constant: padding),
            secondItemView.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: secondItemView.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

}
