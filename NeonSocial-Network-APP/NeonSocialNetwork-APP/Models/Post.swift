//
//  Post.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 4.11.2024.
//

import Foundation

struct Post {
    let id: String?
    let profileImageURL: String?
    let username: String
    let handle: String
    let timestamp: Date
    let nickName: String
    let text: String
    var likeCount: Int
    let commentCount: Int
    var postImageURL: String?
    var userID: String
    var likedBy: [String] 
    var isLiked: Bool
}
