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
        case displayName
        case username
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
        case .displayName:
            keyboardType = .default
            backgroundColor = .secondarySystemFill
            leftViewMode = .always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            layer.masksToBounds = true
            layer.cornerRadius = 8
            autocapitalizationType = .words
            attributedPlaceholder = NSAttributedString(string: "Display Name", attributes: [.foregroundColor: UIColor.systemGray])
            
        case .username:
            keyboardType = .default
            backgroundColor = .secondarySystemFill
            leftViewMode = .always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            layer.masksToBounds = true
            layer.cornerRadius = 8
            attributedPlaceholder = NSAttributedString(string: "Username", attributes: [.foregroundColor: UIColor.systemGray])
            
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
