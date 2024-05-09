//
//  Tweet.swift
//  Twitter-Clone
//
//  Created by Barış Sucuoğlu on 8.05.2024.
//

import Foundation

struct Tweet: Codable, Identifiable {
    var id = UUID().uuidString
    let author: TwitterUser
    let autherID: String
    let tweetContent: String
    var likeCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
