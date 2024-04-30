//
//  ProfileHeaderView.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 30.04.2024.
//

import UIKit

class ProfileHeaderView: UIView {
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubviews(headerImageView, profileImageView, nameLabel, usernameLabel, bioLabel, joinDateImageView, joinedDateLabel)
        headerImageView.image = UIImage(named: "babyYoda")
        nameLabel.text = "kolparator"
        usernameLabel.text = "@kolpakrali"
        
        bioLabel.numberOfLines = 3
        bioLabel.text = "Lorem Ipsum"
        
        joinedDateLabel.text = "Joined 11 February"
        
        headerImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(180)
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
    }
}
