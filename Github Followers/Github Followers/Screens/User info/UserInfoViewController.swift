//
//  UserInfoViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/24.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String) -> Void
}

class UserInfoViewController: UIViewController {
    var username: String!

    let scrollView = UIScrollView()
    let contentView = UIView()

    let headerView = UIView()
    let firstItemView = UIView()
    let secondItemView = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    unowned var delegate: UserInfoVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureViewController()
        getUserInfo()
    }

    @objc func dismissViewController() {
        dismiss(animated: true)
    }

    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func getUserInfo() {
        NetworkManager.shared.getUser(username: username) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            case .failure(let error):
                self.alert(title: "Something went wrong.", message: error.localizedDescription)
            }
        }
    }

    private func configureUIElements(with user: User) {
        self.add(childVC: GFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemViewController(user: user, delegate: self), to: self.firstItemView)
        self.add(childVC: GFFollowerItemViewController(user: user, delegate: self), to: self.secondItemView)
        self.dateLabel.text = "Github since \(user.createdAt.formatted())"
    }
    
    private func layoutUI() {
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

    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoViewController: ItemInfoVCDelegate {
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            alert(title: "Invalid URL", message: "The url attached to this user is invalid.")
            return
        }
        
        self.presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers > 0 else {
            alert(title: "No followers", message: "This user has no followers.")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissViewController()
    }
}
