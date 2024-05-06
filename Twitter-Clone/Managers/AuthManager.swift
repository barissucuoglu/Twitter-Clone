//
//  AuthManager.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 5.05.2024.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    func registerUser(with email: String, password: String) -> AnyPublisher<User, Error> {
        
        Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    
    func loginUser(with email: String, password: String) -> AnyPublisher<User, Error> {
        Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
}
