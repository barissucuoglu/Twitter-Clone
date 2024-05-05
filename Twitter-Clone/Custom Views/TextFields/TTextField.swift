//
//  TTextField.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 5.05.2024.
//

import UIKit

class TTextField: UITextField {
    
    enum TextFieldType {
        case email
        case password
    }
    
    private var textFieldType: TextFieldType!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(textfieldType: TextFieldType) {
        self.init(frame: .zero)
        self.textFieldType = textfieldType
        switch textfieldType {
        case .email:
            placeholder = "Email"
            keyboardType = .emailAddress
            textContentType = .emailAddress
        case .password:
            placeholder = "Password"
            textContentType = .oneTimeCode
            isSecureTextEntry = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textColor = .label
        tintColor = .label
        textAlignment = .left
//        font = .systemFont(ofSize: 14, weight: .semibold)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
}
