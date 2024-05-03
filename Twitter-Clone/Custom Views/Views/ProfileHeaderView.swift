//
//  ProfileHeaderView.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 30.04.2024.
//

import UIKit

class ProfileHeaderView: UIView {
    
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
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var leadingAnchors =  [NSLayoutConstraint]()
    private var trailingAnchors =  [NSLayoutConstraint]()
    
    private let followingCountLabel = TTitleLabel(textAlignment: .left, fontSize: 14)
    private let followingLabel = TSecondaryTitleLabel(fontSize: 14)
    private let followersCountLabel = TTitleLabel(textAlignment: .left, fontSize: 14)
    private let followersLabel = TSecondaryTitleLabel(fontSize: 14)
    
    
    private let profileImageView = AvatarImageView(height: 80)
    private let nameLabel = TTitleLabel(textAlignment: .left, fontSize: 22)
    private let usernameLabel = TSecondaryTitleLabel(fontSize: 18)
    private let bioLabel = TBodyLabel(textAlignment: .justified)
    
    private let joinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    private let joinedDateLabel = TSecondaryTitleLabel(fontSize: 14)
    
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
                    joinedDateLabel, followingCountLabel, followingLabel, followersCountLabel, followersLabel, sectionStackView, indicator)
        headerImageView.image = UIImage(named: "babyYoda")
        nameLabel.text = "kolparator"
        usernameLabel.text = "@kolpakrali"
        
        bioLabel.numberOfLines = 3
        bioLabel.text = "Lorem Ipsum"
        
        joinedDateLabel.text = "Joined 11 February"
        
        followersLabel.text = "Followers"
        followingLabel.text = "Following"
        
        followingCountLabel.text = "400"
        followersCountLabel.text = "200"
        
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
            indicator.topAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[0].bottomAnchor, constant: -4),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
}
