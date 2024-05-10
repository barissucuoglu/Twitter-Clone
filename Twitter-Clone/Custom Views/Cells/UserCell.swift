//
//  UserCell.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 9.05.2024.
//

import UIKit

class UserCell: UITableViewCell {

    static let reuseID = "UserCell"
    
    private let avatarImageView = AvatarImageView(height: 45)
    private let displayNameLabel = TTitleLabel(textAlignment: .left, fontSize: 18)
    private let usernameLabel = TSecondaryTitleLabel(fontSize: 16)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(user: TwitterUser) {
        displayNameLabel.text = user.displayName
        usernameLabel.text = "@\(user.username)"
        avatarImageView.sd_setImage(with: URL(string: user.avatarPath))
    }
    
    
    private func configure() {
        contentView.addSubviews(avatarImageView, displayNameLabel, usernameLabel)
        
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        displayNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(displayNameLabel.snp.trailing).offset(10)
            make.centerY.equalTo(displayNameLabel.snp.centerY)
        }
    }
    
}
