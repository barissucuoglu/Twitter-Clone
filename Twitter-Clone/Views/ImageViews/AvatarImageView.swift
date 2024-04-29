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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentMode = .scaleAspectFit
        backgroundColor = .secondaryLabel
        tintColor = .label
        layer.cornerRadius = 24
        layer.masksToBounds = true
        clipsToBounds = true
        image = placeholderImage
    }

}
