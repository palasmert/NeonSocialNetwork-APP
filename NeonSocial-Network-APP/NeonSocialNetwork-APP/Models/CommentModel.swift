//
//  CommentModel.swift
//  NeonSocialNetwork-APP
//
//  Created by Mert Palas on 10.11.2024.
//

import Foundation

struct Comment: Codable {
    let username: String
    let handle: String
    let text: String
    let timestamp: Date
    let profileImageURL: String?
}
