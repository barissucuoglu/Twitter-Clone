//
//  ProfileDataFormVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 7.05.2024.
//

import UIKit
import PhotosUI
import Combine

class ProfileDataFormVC: UIViewController {
    
    private let viewModel = ProfileDataFormViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let fillTitleLabel = TTitleLabel(textAlignment: .center, fontSize: 32)
    private let avatarImageView = AvatarImageView(height: 120)
    private let displayNameTextField = TTextField(textfieldType: .displayName)
    private let usernameTextField = TTextField(textfieldType: .username)
    private let submitButton = TButton(height: 50, fontStize: 16, buttonTitle: "Submit")
    
    private let bioTextView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .secondarySystemFill
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textView.text = "Tell the world about yourself"
        textView.textColor = .gray
        return textView
    }()
    
    
    private func bindViews() {
        displayNameTextField.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        
        viewModel.$isFormValid.sink { [weak self] validationState in
            self?.submitButton.isEnabled = validationState
        }.store(in: &subscriptions)
        
        viewModel.$isUserOnboardingDone.sink { [weak self] succes in
            if succes {
                self?.dismiss(animated: true)
            }
        }.store(in: &subscriptions)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViews()
    }
    
    
    @objc func didUpdateDisplayName() {
        viewModel.displayName = displayNameTextField.text
        viewModel.validateUserProfileForm()
    }
    
     @objc func didUpdateUsername() {
        viewModel.username = usernameTextField.text
        viewModel.validateUserProfileForm()
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubviews(fillTitleLabel, avatarImageView, displayNameTextField, usernameTextField, bioTextView, submitButton)
        
        submitButton.isEnabled = false
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        
        isModalInPresentation = true
        fillTitleLabel.text = "Fill in you data"
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDismiss)))
        
        bioTextView.delegate = self
        displayNameTextField.delegate = self
        usernameTextField.delegate = self
        
        avatarImageView.image = UIImage(systemName: "camera.fill")
        avatarImageView.backgroundColor = .lightGray
        avatarImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUpload))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fillTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(fillTitleLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        displayNameTextField.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(32)
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(displayNameTextField.snp.bottom).offset(32)
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        bioTextView.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(32)
            make.leading.equalTo(displayNameTextField.snp.leading)
            make.trailing.equalTo(displayNameTextField.snp.trailing)
            make.height.equalTo(150)
        }
        
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-25)
            make.leading.equalTo(displayNameTextField.snp.leading)
            make.trailing.equalTo(displayNameTextField.snp.trailing)
        }
    }
    
    
    @objc func didTapUpload() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true)
    }
    
    
    @objc func didTapSubmitButton() {
        viewModel.uploadAvatar()
    }
    
    
    @objc func didTapDismiss() {
        view.endEditing(true)
    }
}


extension ProfileDataFormVC: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - 100), animated: true)
        if textView.textColor == UIColor.gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if textView.text == "" || textView.text.count == 0 {
            textView.textColor = .gray
            textView.text = "Tell the world about yourself"
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio = textView.text
        viewModel.validateUserProfileForm()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 100), animated: true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension ProfileDataFormVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let self = self else { return }
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.avatarImageView.contentMode = .scaleToFill
                        self.avatarImageView.image = image
                        self.viewModel.imageData = image
                        self.viewModel.validateUserProfileForm()
                    }
                }
            }
        }
    }
}
