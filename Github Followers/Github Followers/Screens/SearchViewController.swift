//
//  SearchViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/12.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let usernameTextField = GFTextField()
    private let searchButton = GFButton(color: .systemGreen, title: "Get Followers", systemName: "person.3")

    private var isUsernameEntered: Bool { usernameTextField.text?.isEmpty == false }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        usernameTextField.text = ""
    }

    private func configure() {
        view.addSubviews(logoImageView, usernameTextField, searchButton)
        configureLogoImageView()
        configureTextField()
        configureButton()
        createDismissKeyboardTapGesture()
    }

    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "github")

        let topPadding: CGFloat = UIWindow.current?.bounds.height ?? 0 > 700 ? 80 : 20
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureTextField() {
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureButton() {
        searchButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @objc private func pushFollowerListVC() {
        guard isUsernameEntered else {
            alert(title: "Empty Username", message: "Please enter an username. We need to know who to look for.")
            return
        }
        usernameTextField.resignFirstResponder()
        let followerListVC = FollowerListViewController(username: usernameTextField.text ?? "")
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
