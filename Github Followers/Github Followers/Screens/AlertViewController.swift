//
//  AlertViewController.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/13.
//

import UIKit

class AlertViewController: UIViewController {
    let containerView = GFAlertContainerView()
    let titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GFBodyLabel(textAlignment: .center)
    let button = GFButton(backgroundColor: .systemPink, title: "OK")

    private let padding: CGFloat = 20
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?

    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLable()
        configureActionButton()
        configureBodyLabel()
    }

    private func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func configureTitleLable() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong."
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func configureBodyLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete the request."
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -12)
        ])
    }

    private func configureActionButton() {
        containerView.addSubview(button)
        button.setTitle(buttonTitle ?? "OK", for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

#Preview {
    return AlertViewController(alertTitle: "Alert", message: "This is message", buttonTitle: "OK")
}
