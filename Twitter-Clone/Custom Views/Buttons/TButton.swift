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
    
    convenience init(height: CGFloat, fontStize: CGFloat, buttonTitle: String) {
        self.init(frame: .zero)
        setTitle(buttonTitle, for: .normal)
        layer.cornerRadius = height / 2
        titleLabel?.font = .systemFont(ofSize: fontStize, weight: .bold)
        snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    
    private func configure() {
        backgroundColor = UIColor(hex: "#1DA1F2")
        tintColor = .white
        layer.masksToBounds = true
    }
    
}
