//
//  SearchViewModel.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 9.05.2024.
//

import Foundation
import Combine

final class SearchViewModel {
    
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func search(with query: String, _ completed: @escaping([TwitterUser]) -> Void) {
        DatabaseManager.shared.collectionUsers(search: query).sink { [weak self] completed in
            if case .failure(let error) = completed {
                self?.error = error.localizedDescription
            }
        } receiveValue: { users in
            print(users)
            completed(users)
        }.store(in: &subscriptions)
    }
}
