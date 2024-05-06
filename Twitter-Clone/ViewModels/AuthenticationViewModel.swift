//
//  RegisterViewModel.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 5.05.2024.
//

import Foundation
import Firebase
import Combine

final class AuthenticationViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateAuthenticationForm() {
        guard let email = email,
              let password = password else {
            isAuthenticationFormValid = false
            return
        }
        isAuthenticationFormValid = isValidEmail(for: email) && password.count >= 8
    }
    
    func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func createUser() {
        guard let email = email,
              let password = password else { return }
        
        AuthManager.shared.registerUser(with: email, password: password)
            .sink { [weak self] completed in
                
                if case .failure(let error) = completed {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }.store(in: &subscriptions)
    }
    
    
    func loginUser() {
        guard let email = email,
              let password = password else { return }
        
        AuthManager.shared.loginUser(with: email, password: password)
            .sink { [weak self] completed in
                
                if case .failure(let error) = completed {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }.store(in: &subscriptions)
    }
}
