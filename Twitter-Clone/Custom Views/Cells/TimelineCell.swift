//
//  TimelineCell.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 29.04.2024.
//

import UIKit
import SnapKit

protocol TweetInteractionDelegate: AnyObject {
    func didTapReplyButton()
    func didTapRetweetButton()
    func didTapLikeButton()
    func didTapShareButton()
}

class TimelineCell: UITableViewCell {

    static let reuseID = "TimelineCell"
    
    weak var delegate: TweetInteractionDelegate?
    
    private let avatarImageView = AvatarImageView(height: 45)
    private let displayNameLabel = TTitleLabel(textAlignment: .left, fontSize: 18)
    private let usernameLabel = TSecondaryTitleLabel(fontSize: 16)
    private let tweetLabel = TBodyLabel(textAlignment: .justified)
    
    private let stackView = UIStackView()
    
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "reply"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureStackView()
        configureButtons()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        selectionStyle = .none
        contentView.addSubviews(avatarImageView, displayNameLabel, usernameLabel, tweetLabel, stackView)
        
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        avatarImageView.layer.cornerRadius = 22.5
        
        displayNameLabel.text = "Barış Sucuoğlu"
        usernameLabel.text = "@barissuc"
        tweetLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(14)
        }
        
        displayNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(displayNameLabel.snp.trailing).offset(10)
            make.centerY.equalTo(displayNameLabel.snp.centerY)
        }
        
        tweetLabel.snp.makeConstraints { make in
            make.top.equalTo(displayNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(displayNameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(tweetLabel.snp.leading)
            make.top.equalTo(tweetLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(tweetLabel.snp.trailing)
        }
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        [replyButton, retweetButton, likeButton, shareButton].forEach { button in
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.width.equalTo(20)
            }
        }
    }
    
    
    private func configureButtons() {
        replyButton.addTarget(self, action: #selector(replyButtonTapped), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(retweetButtonTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    @objc func replyButtonTapped() {
        delegate?.didTapReplyButton()
    }
    
    @objc func retweetButtonTapped() {
        delegate?.didTapRetweetButton()
    }
    
    @objc func likeButtonTapped() {
        delegate?.didTapLikeButton()
    }
    
    @objc func shareButtonTapped() {
        delegate?.didTapShareButton()
    }
    
}
