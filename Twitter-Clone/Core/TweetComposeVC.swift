//
//  TweetComposeVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 8.05.2024.
//

import UIKit

class TweetComposeVC: UIViewController {
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureVC()
    }
    
    
    private func configureNavigationController() {
        navigationController?.navigationBar.layer.cornerRadius = 10
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 44
        let postButton = TButton(height: navigationBarHeight - 8, fontStize: 18, buttonTitle: "Post")
        postButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        let barButtonItem = UIBarButtonItem(customView: postButton)
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
}
