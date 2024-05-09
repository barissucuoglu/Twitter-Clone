//
//  TweetComposeVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 8.05.2024.
//

import UIKit
import Combine

class TweetComposeVC: UIViewController {
    
    private let viewModel = TweetComposeViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    let postButton = TButton(height: 32, fontStize: 18, buttonTitle: "Post")
    
    private let tweetContentTextView: UITextView = {
       let textView = UITextView()
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textView.text = "What's happening?"
        textView.textColor = .gray
        return textView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
    }
    
    
    private func bindViews() {
        viewModel.$isValidToTweet.sink { [weak self] validState in
            self?.postButton.isEnabled = validState
        }.store(in: &subscriptions)
        
        viewModel.$shouldDismissComposer.sink { [weak self] succes in
            if succes {
                self?.dismiss(animated: true)
            }
        }.store(in: &subscriptions)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureVC()
        bindViews()
    }
    
    
    private func configureNavigationController() {
        postButton.isEnabled = false
        postButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        let barButtonItem = UIBarButtonItem(customView: postButton)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        postButton.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissVC))
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(tweetContentTextView)
        
        tweetContentTextView.delegate = self
        
        tweetContentTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(16)
        }
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    @objc func didTapPostButton() {
        viewModel.dispatchTweet()
    }

}

extension TweetComposeVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = .gray
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
}
