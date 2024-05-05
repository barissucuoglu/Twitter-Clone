//
//  TButton.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 5.05.2024.
//

import UIKit

class TButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(height: CGFloat, fontStize: CGFloat) {
        self.init(frame: .zero)
        layer.cornerRadius = height / 2
        titleLabel?.font = .systemFont(ofSize: fontStize, weight: .bold)
        snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    
    private func configure() {
        setTitle("Create Account", for: .normal)
        backgroundColor = UIColor(hex: "#1DA1F2")
        tintColor = .white
        layer.masksToBounds = true
    }
    
}
