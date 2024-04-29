//
//  TimelineCell.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 29.04.2024.
//

import UIKit
import SnapKit

class TimelineCell: UITableViewCell {

    static let reuseID = "TimelineCell"
    
    private let avatarImageView = AvatarImageView(frame: .zero)
    private let displayNameLabel = TTitleLabel(textAlignment: .left, fontSize: 18)
    private let usernameLabel = TSecondaryTitleLabel(fontSize: 16)
    private let tweetLabel = TBodyLabel(textAlignment: .justified)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubviews(avatarImageView, displayNameLabel, usernameLabel, tweetLabel)
        
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        avatarImageView.layer.cornerRadius = 22.5
        
        displayNameLabel.text = "Barış Sucuoğlu"
        usernameLabel.text = "@barissuc"
        tweetLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(14)
            make.height.width.equalTo(45)
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
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
}
