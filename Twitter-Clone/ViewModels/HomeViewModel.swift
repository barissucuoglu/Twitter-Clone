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
    @Published var tweets: [Tweet] = []
    
    private var subscription: Set<AnyCancellable> = []
    
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
                self?.fetchTweets()
            })
            .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] user in
            self?.user = user
        }.store(in: &subscription)
    }
    
    
    func fetchTweets() {
        guard let userID = user?.id else { return }
        DatabaseManager.shared.collectionTweets(retrieveTweets: userID).sink { [weak self] completed in
            if case .failure(let error) = completed {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] tweets in
            self?.tweets = tweets
        }.store(in: &subscription)

    }
}
