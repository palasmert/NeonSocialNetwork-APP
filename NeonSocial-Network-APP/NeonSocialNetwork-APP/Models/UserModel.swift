//
//  UserModel.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 6.11.2024.
//

import UIKit

struct UserData: Codable {
    let uid: String
    let email: String?
    let username: String?
    let nickName: String?
    let profileImageURL: String?
    let bio: String?
    let followersCount: Int?       
    let followingCount: Int?
    let postCount: Int?
}
