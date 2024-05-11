//
//  ProfileHeaderView.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 30.04.2024.
//

import UIKit
import Combine

class ProfileHeaderView: UIView {
    
    private var currentFollowState: ProfileFollowingState = .personal
    var followedButtonActionPublisher: PassthroughSubject<ProfileFollowingState, Never> = PassthroughSubject()
    
    private enum SectionButtons: String {
        case posts = "Posts"
        case tweetAndReplies = "Tweets & Replies"
        case media = "Media"
        case likes = "Likes"
        
        var index: Int {
            switch self {
            case .posts:
                return 0
            case .tweetAndReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    
    private var selectedIndex = 0 {
        didSet {
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                    guard let self = self else { return }
                    sectionStackView.arrangedSubviews[i].tintColor = i == selectedIndex ? .label : .secondaryLabel
                    leadingAnchors[i].isActive = i == selectedIndex ? true : false
                    trailingAnchors[i].isActive = i == selectedIndex ? true : false
                    layoutIfNeeded()
                }
            }
        }
    }
    
    private var tabs: [UIButton] = ["Posts", "Tweets & Replies", "Media", "Likes"].map { buttonTitle in
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .secondaryLabel
        return button
    }
    
    private lazy var sectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#1DA1F2")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var leadingAnchors =  [NSLayoutConstraint]()
    private var trailingAnchors =  [NSLayoutConstraint]()
    
    private let followButton = TButton(height: 40, fontStize: 16, buttonTitle: "Follow")
    
    var followingCountLabel = TTitleLabel(textAlignment: .left, fontSize: 14)
    private let followingLabel = TSecondaryTitleLabel(fontSize: 14)
    var followersCountLabel = TTitleLabel(textAlignment: .left, fontSize: 14)
    private let followersLabel = TSecondaryTitleLabel(fontSize: 14)
    
    
    var profileImageView = AvatarImageView(height: 80)
    var nameLabel = TTitleLabel(textAlignment: .left, fontSize: 22)
    var usernameLabel = TSecondaryTitleLabel(fontSize: 18)
    var bioLabel = TBodyLabel(textAlignment: .justified)
    
    private let joinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    var joinedDateLabel = TSecondaryTitleLabel(fontSize: 14)
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureSectionButtons()
        configureFollowButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSectionButtons() {
        for (i, button) in sectionStackView.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            
            if selectedIndex == i {
                button.tintColor = .label
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
    }
    
    
    private func configureFollowButtonAction() {
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    
    @objc private func didTapFollowButton() {
        followedButtonActionPublisher.send(currentFollowState)
    }
    
    
    func configureButtonAsPersonal() {
        followButton.isHidden = true
        currentFollowState = .personal
    }
    
    
    func configureButtonAsUnfollow() {
        followButton.setTitle("Unfollow", for: .normal)
        followButton.backgroundColor = .systemBackground
        followButton.setTitleColor(UIColor(hex: "#1DA1F2"), for: .normal)
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = UIColor(hex: "#1DA1F2").cgColor
        followButton.isHidden = false
        currentFollowState = .userIsFollowed
    }
    
    
    func configureButtonAsFollow() {
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = UIColor(hex: "#1DA1F2")
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.borderColor = UIColor.clear.cgColor
        followButton.isHidden = false
        currentFollowState = .userIsUnfollowed
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        switch buttonTitle {
        case SectionButtons.posts.rawValue:
            selectedIndex = 0
        case SectionButtons.tweetAndReplies.rawValue:
            selectedIndex = 1
        case SectionButtons.media.rawValue:
            selectedIndex = 2
        case SectionButtons.likes.rawValue:
            selectedIndex = 3
        default:
            selectedIndex = 0
        }
    }
    
    
    private func configure() {
        addSubviews(headerImageView, profileImageView, nameLabel, usernameLabel, bioLabel, joinDateImageView,
                    joinedDateLabel, followingCountLabel, followingLabel, followersCountLabel, followersLabel, sectionStackView, indicator, followButton)
        headerImageView.image = UIImage(named: "babyYoda")
        
        bioLabel.numberOfLines = 3
        
        joinedDateLabel.text = "Joined 11 February"
        
        followersLabel.text = "Followers"
        followingLabel.text = "Following"

        for i in 0..<tabs.count {
            let leadingAnchor = indicator.leadingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            let trailingAnchor = indicator.trailingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(150)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(headerImageView.snp.bottom).offset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.leading)
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(usernameLabel.snp.bottom).offset(6)
        }
        
        joinDateImageView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(bioLabel.snp.bottom).offset(6)
        }
        
        joinedDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(joinDateImageView.snp.trailing).offset(6)
            make.centerY.equalTo(joinDateImageView.snp.centerY)
        }
        
        followingCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(joinedDateLabel.snp.bottom).offset(10)
        }
        
        followingLabel.snp.makeConstraints { make in
            make.leading.equalTo(followingCountLabel.snp.trailing).offset(4)
            make.bottom.equalTo(followingCountLabel.snp.bottom)
        }
        
        followersCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(followingLabel.snp.trailing).offset(8)
            make.bottom.equalTo(followingCountLabel.snp.bottom)
        }
        
        followersLabel.snp.makeConstraints { make in
            make.leading.equalTo(followersCountLabel.snp.trailing).offset(4)
            make.bottom.equalTo(followingCountLabel.snp.bottom)
        }
        
        sectionStackView.snp.makeConstraints { make in
            make.top.equalTo(followersCountLabel.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        
        NSLayoutConstraint.activate([
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStackView.bottomAnchor, constant: -4),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        followButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(usernameLabel.snp.centerY)
            make.width.equalTo(120)
        }
    }
}
