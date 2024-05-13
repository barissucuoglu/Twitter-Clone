//
//  ProfileViewModel.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 8.05.2024.
//

import Foundation
import Combine
import FirebaseAuth

enum ProfileFollowingState {
    case userIsFollowed
    case userIsUnfollowed
    case personal
}

final class ProfileViewModel: ObservableObject {
    
    @Published var user: TwitterUser
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    @Published var currentFollowingState: ProfileFollowingState = .personal
    
    private var subscription: Set<AnyCancellable> = []
    
    init(user: TwitterUser) {
        self.user = user
        checkIsFollowed()
    }

    
    private func checkIsFollowed() {
        guard let personalUserID = Auth.auth().currentUser?.uid,
        personalUserID != user.id
        else {
            currentFollowingState = .personal
            return
        }
        
        DatabaseManager.shared.collectionFollowings(isFollower: personalUserID, following: user.id).sink { [weak self] completed in
            if case .failure(let error) = completed {
                self?.error = error.localizedDescription
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] isFollowed in
            self?.currentFollowingState = isFollowed ? .userIsFollowed : .userIsUnfollowed
        }.store(in: &subscription)
    }
    
    
    func follow() {
        guard let personalUserID = Auth.auth().currentUser?.uid else { return }
        
        DatabaseManager.shared.collectionFollowings(follower: personalUserID, following: user.id).sink { [weak self] completed in
            if case .failure(let error) = completed {
                self?.error = error.localizedDescription
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] isFollowed in
            self?.currentFollowingState = .userIsFollowed
        }.store(in: &subscription)

    }
    
    
    func unFollow() {
        guard let personalUserID = Auth.auth().currentUser?.uid else { return }

        DatabaseManager.shared.collectionFollowings(delete: personalUserID, following: user.id).sink { [weak self] completed in
            if case .failure(let error) = completed {
                self?.error = error.localizedDescription
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] isUnfollowed in
            self?.currentFollowingState = .userIsUnfollowed
        }.store(in: &subscription)

    }
    
    
    func getFormattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
    
    
    func fetchUserTweets() {
        DatabaseManager.shared.collectionTweets(retrieveTweets: user.id).sink { [weak self] completed in
            if case .failure(let error) = completed {
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] tweets in
            self?.tweets = tweets
        }.store(in: &subscription)
    }
}
