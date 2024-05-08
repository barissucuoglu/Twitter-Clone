//
//  HomeVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 29.04.2024.
//

import UIKit
import FirebaseAuth
import Combine

class HomeVC: UIViewController {
    
    private let viewModel = HomeViewModel()
    private var subscrpition: Set<AnyCancellable> = []
    
    private let tweetButton = TButton()
    private let timelineTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.reuseID)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        checkAuthentication()
        viewModel.retrieveUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationContoller()
        configureVC()
        bindViews()
    }
    
    
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            if !user.isUserOnboarded {
                self?.completedOnboarding()
            }
        }.store(in: &subscrpition)
    }
    
    
    private func completedOnboarding() {
        let destVC = ProfileDataFormVC()
        present(destVC, animated: true)
    }
    
    
    private func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            let destVC = UINavigationController(rootViewController: OnboardingVC())
            destVC.modalPresentationStyle = .fullScreen
            present(destVC, animated: false)
        }
    }
    
    
    private func configureNavigationContoller() {
        let size: CGFloat = 36
        let logoImageView = UIImageView(frame:  CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = Images.logo
        navigationItem.titleView = logoImageView
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(timelineTableView, tweetButton)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        timelineTableView.frame = view.bounds
        
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        tweetButton.setImage(plusSign, for: .normal)
        tweetButton.addTarget(self, action: #selector(didTapTweetButton), for: .touchUpInside)
        tweetButton.layer.cornerRadius = 30
        tweetButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(120)
            make.trailing.equalToSuperview().inset(25)
            make.width.height.equalTo(60)
        }
    }
    
    
    @objc func didTapProfile() {
        let destVC = ProfileVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @objc func didTapSignOut() {
        try? Auth.auth().signOut()
        checkAuthentication()
    }
    
    @objc func didTapTweetButton() {
        let destVC = UINavigationController(rootViewController: TweetComposeVC())
        destVC.modalPresentationStyle = .fullScreen
        present(destVC, animated: true)
    }
    

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.reuseID, for: indexPath) as! TimelineCell
        cell.delegate = self
        return cell
    }
    
    
}

extension HomeVC: TweetInteractionDelegate {
    
    func didTapReplyButton() {
        print("Reply")
    }
    
    func didTapRetweetButton() {
        print("Retweet")
    }
    
    func didTapLikeButton() {
        print("Like")
    }
    
    func didTapShareButton() {
        print("Share")
    }
}
