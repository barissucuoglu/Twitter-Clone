//
//  OnboardingVC.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 4.05.2024.
//

import UIKit

class OnboardingVC: UIViewController {
    
    private let welcomeLabel = TTitleLabel(textAlignment: .center, fontSize: 32)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        
    }
    
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeLabel)
        welcomeLabel.text = "See what's happening in the world right now."
        welcomeLabel.numberOfLines = 0
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

}
