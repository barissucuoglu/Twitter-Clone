//
//  HomeViewModel.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 7.05.2024.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    
    private var subscription: Set<AnyCancellable> = []
    
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] user in
            self?.user = user
        }.store(in: &subscription)
    }
}
