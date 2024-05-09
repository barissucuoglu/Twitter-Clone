//
//  TweetComposeViewModel.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 8.05.2024.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewModel {
    
    private var subscriptions: Set<AnyCancellable> = []
    private var user: TwitterUser?
    var tweetContent: String = ""
    
    @Published var isValidToTweet: Bool = false
    @Published var error: String?
    @Published var shouldDismissComposer: Bool = false
    
    
    
    func validateToTweet() {
        isValidToTweet = !tweetContent.isEmpty
    }
    
    
    func dispatchTweet() {
        guard let user = user else { return }
        
        let tweet = Tweet(author: user, autherID: user.id, tweetContent: tweetContent, likeCount: 0, likers: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.collectionTweets(dispatch: tweet).sink { [weak self] completed in
            guard let self = self else { return }
            if case .failure(let error) = completed {
                print(error.localizedDescription)
                self.error = error.localizedDescription
            }
        } receiveValue: { [weak self] state in
            self?.shouldDismissComposer = state
        }.store(in: &subscriptions)

    }
    
    func getUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        DatabaseManager.shared.collectionUsers(retrieve: userID).sink { [weak self] completed in
            guard let self = self else { return }
            if case .failure(let error) = completed {
                print(error.localizedDescription)
                self.error = error.localizedDescription
            }
        } receiveValue: { [weak self] twitterUser in
            self?.user = twitterUser
        }.store(in: &subscriptions)

    }
}
