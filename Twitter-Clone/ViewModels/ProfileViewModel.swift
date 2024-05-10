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
    
    @Published var user: TwitterUser
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscription: Set<AnyCancellable> = []
    
    init(user: TwitterUser) {
        self.user = user
    }
    
    
    func getFormattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
    
    
    func fetchUserTweets() {
        DatabaseManager.shared.collectionTweets(retrieveTweets: user.id).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] tweets in
            self?.tweets = tweets
        }.store(in: &subscription)

    }
}
