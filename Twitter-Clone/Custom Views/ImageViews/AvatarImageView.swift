//
//  AvatarImageView.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 29.04.2024.
//

import UIKit

class AvatarImageView: UIImageView {
    
    private let placeholderImage = UIImage(systemName: "person.fill")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(height: CGFloat) {
        self.init(frame: .zero)
        self.snp.makeConstraints { make in
            make.width.height.equalTo(height)
        }
        layer.cornerRadius = height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentMode = .scaleAspectFit
        backgroundColor = .secondaryLabel
        tintColor = .gray
//        layer.cornerRadius = 24
        layer.masksToBounds = true
        clipsToBounds = true
        image = placeholderImage
    }

}
