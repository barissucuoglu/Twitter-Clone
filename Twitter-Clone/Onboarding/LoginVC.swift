//
//  LoginVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 6.05.2024.
//

import UIKit
import Combine

class LoginVC: UIViewController {
    
    private var viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let loginTitleLabel = TTitleLabel(textAlignment: .left, fontSize: 32)
    private let emailTextField = TTextField(textfieldType: .email)
    private let passwordTextField = TTextField(textfieldType: .password)
    private let loginButton = TButton(height: 50, fontStize: 16, buttonTitle: "Login")
    
    @objc private func didChangeEmailField() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthenticationForm()
    }
    
     @objc private func didChangePasswordField() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthenticationForm()
    }
    
    private func bindViews() {
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        
        viewModel.$isAuthenticationFormValid.sink { [weak self] validationState in
            guard let self = self else { return }
            self.loginButton.isEnabled = validationState
        }.store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            guard let self = self else { return }
            guard user != nil else { return }
            guard let onboardingVC = self.navigationController?.viewControllers.first as? OnboardingVC else { return }
            onboardingVC.dismiss(animated: true)
        }.store(in: &subscriptions)
        
        
        viewModel.$error.sink { [weak self] errorState in
            guard let error = errorState else { return }
            self?.presentAlert(with: error)
        }.store(in: &subscriptions)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViews()
    }
    
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    

    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(loginTitleLabel, emailTextField, passwordTextField, loginButton)
        
        loginTitleLabel.text = "Login to your account"
        loginButton.addTarget(self, action: #selector(didButtonLoginTap), for: .touchUpInside)
        loginButton.isEnabled = false
        
        loginTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(32)
            make.width.equalTo(180)
        }
    }
    
    @objc func didButtonLoginTap() {
        viewModel.loginUser()
    }

}
