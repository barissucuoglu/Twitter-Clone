//
//  OnboardingVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 4.05.2024.
//

import UIKit

class OnboardingVC: UIViewController {
    
    private let welcomeLabel = TTitleLabel(textAlignment: .center, fontSize: 32)
    private let loginLabel = TSecondaryTitleLabel(fontSize: 14)
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tintColor = UIColor(hex: "#1DA1F2")
        return button
    }()
    
    private let createAccountButton = TButton(height: 60, fontStize: 24, buttonTitle: "Create Account")
    
    private let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "By signing up, you agree to our Terms & Conditions and Privacy Policy, Including Cookie Use.")
        
        let font = UIFont.systemFont(ofSize: 14)
        
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.link, value: "terms://TermsAndConditions", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        attributedString.addAttribute(.link, value: "cookie://cookieUse", range: (attributedString.string as NSString).range(of: "Cookie Use."))
        
        let textView = UITextView()
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        textView.backgroundColor = .clear
        textView.attributedText = attributedString
        textView.textColor = .label
        textView.isSelectable = true
        textView.isEditable = false
        textView.delaysContentTouches = false
        textView.isScrollEnabled = false
        
        return textView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(welcomeLabel, createAccountButton, termsTextView, loginLabel, loginButton)
        
        welcomeLabel.text = "See what's happening in the world right now."
        welcomeLabel.numberOfLines = 0
        termsTextView.delegate = self
        
        loginLabel.text = "Have an account already?"
        loginLabel.tintColor = .gray
        
        createAccountButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            //            make.height.equalTo(60)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(createAccountButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerY.equalTo(loginLabel.snp.centerY)
            make.leading.equalTo(loginLabel.snp.trailing).offset(12)
        }
    }
    
    @objc func didTapRegisterButton() {
        let destVC = RegisterVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @objc func didTapLoginButton() {
        let destVC = LoginVC()
        navigationController?.pushViewController(destVC, animated: true)
        
    }
    
}

extension OnboardingVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "terms" {
            showWebViewerController(with: "https://twitter.com/en/tos")
        } else if URL.scheme == "privacy" {
            showWebViewerController(with: "https://help.twitter.com/en/rules-and-policies")
        } else if URL.scheme == "cookie" {
            showWebViewerController(with: "https://help.twitter.com/en/rules-and-policies/x-cookies")
        }
        return true
    }
    
    
    private func showWebViewerController(with urlString: String) {
        let destVC = WebVC(with: urlString)
        let nav = UINavigationController(rootViewController: destVC)
        present(nav, animated: true)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
