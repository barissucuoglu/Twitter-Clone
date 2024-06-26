//
//  RegisterVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 5.05.2024.
//

import UIKit
import Combine

class RegisterVC: UIViewController {
    
    private var viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let registerTitleLabel = TTitleLabel(textAlignment: .left, fontSize: 32)
    private let emailTextField = TTextField(textfieldType: .email)
    private let passwordTextField = TTextField(textfieldType: .password)
    private let registerButton = TButton(height: 50, fontStize: 16, buttonTitle: "Create Account")
    
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
            self.registerButton.isEnabled = validationState
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
        configureDismissKeyboard()
        bindViews()
    }
    
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    
    private func configureDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(registerTitleLabel, emailTextField, passwordTextField, registerButton)
        
        registerTitleLabel.text = "Create your account"
        registerButton.addTarget(self, action: #selector(didButtonRegisterTap), for: .touchUpInside)
        registerButton.isEnabled = false
        
        registerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(registerTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(32)
            make.width.equalTo(180)
        }
    }
    
    
    @objc func didButtonRegisterTap() {
        viewModel.createUser()
    }

}
