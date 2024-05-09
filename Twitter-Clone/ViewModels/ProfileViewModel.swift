//
//  ProfileViewModel.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 8.05.2024.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscription: Set<AnyCancellable> = []
    
    
    func retrieveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retrieve: id).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] user in
            self?.user = user
            self?.fetchUserTweets()
        }.store(in: &subscription)
    }
    
    
    func getFormattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
    
    
    func fetchUserTweets() {
        guard let user = user else { return }
        DatabaseManager.shared.collectionTweets(retrieveTweets: user.id).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] tweets in
            self?.tweets = tweets
        }.store(in: &subscription)

    }
}
