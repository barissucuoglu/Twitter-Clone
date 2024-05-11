//
//  ProfileVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 30.04.2024.
//

import UIKit
import Combine
import SDWebImage

class ProfileVC: UIViewController {
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var subscriptions: Set<AnyCancellable> = []
    
    private let statusBar: UIView = {
       let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.opacity = 0
        return view
    }()
    
    private var isStatusBarHidden = true
    
    private lazy var headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 390))
    
    private let profileTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TimelineCell.self, forCellReuseIdentifier: TimelineCell.reuseID)
        return tableView
    }()
    
    
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let self  = self else { return }
            DispatchQueue.main.async {
                self.headerView.nameLabel.text = user.displayName
                self.headerView.usernameLabel.text = "@\(user.username)"
                self.headerView.bioLabel.text = user.bio
                self.headerView.followersCountLabel.text = "\(user.followersCount)"
                self.headerView.followingCountLabel.text = "\(user.followingCount)"
                self.headerView.profileImageView.contentMode = .scaleAspectFill
                self.headerView.profileImageView.sd_setImage(with: URL(string: user.avatarPath))
                self.headerView.joinedDateLabel.text = "Joined \(self.viewModel.getFormattedDate(from: user.crateOn))"
            }
        }.store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async { self?.profileTableView.reloadData() }
        }.store(in: &subscriptions)
        
        
        viewModel.$currentFollowingState.sink { [weak self] state in
            switch state {
            case .personal:
                self?.headerView.configureButtonAsPersonal()
            case .userIsFollowed:
                self?.headerView.configureButtonAsUnfollow()
            case .userIsUnfollowed:
                self?.headerView.configureButtonAsFollow()
            }
        }.store(in: &subscriptions)
        
        
        headerView.followedButtonActionPublisher.sink { [weak self] state in
            switch state {
            case .userIsFollowed:
                self?.viewModel.unFollow()
            case .userIsUnfollowed:
                self?.viewModel.follow()
            case .personal:
                return
            }
        }.store(in: &subscriptions)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureVC()
        bindViews()
        viewModel.fetchUserTweets()
    }
    
    
    private func configureNavigationController() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(profileTableView, statusBar)
        profileTableView.delegate = self
        profileTableView.dataSource = self

        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        
        let iphoneModelHeight: CGFloat = view.bounds.height > 800 ? 45 : 20
        
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        statusBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(iphoneModelHeight)
        }

    }


}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.reuseID, for: indexPath) as! TimelineCell
        let tweet = viewModel.tweets[indexPath.row]
        cell.set(tweet: tweet)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            }
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
}
