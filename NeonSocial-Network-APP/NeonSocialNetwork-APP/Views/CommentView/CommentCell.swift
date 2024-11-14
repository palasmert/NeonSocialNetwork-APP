//
//  CommentCell.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 6.11.2024.
//
// 

import UIKit
import SnapKit

class CommentCell: UITableViewCell {
    static let identifier = "CommentCell"
    
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let handleAndTimeLabel = UILabel()
    private let commentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(handleAndTimeLabel)
        contentView.addSubview(commentLabel)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
        }
        
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        handleAndTimeLabel.font = UIFont.systemFont(ofSize: 12)
        handleAndTimeLabel.textColor = .systemGray2
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.numberOfLines = 0
        
        // Layout constraints
        usernameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(profileImageView.snp.right).offset(8)
        }
        
        handleAndTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
            make.left.equalTo(usernameLabel)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(handleAndTimeLabel.snp.bottom).offset(4)
            make.left.equalTo(usernameLabel)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with comment: Comment) {
        usernameLabel.text = comment.username
        handleAndTimeLabel.text = "\(comment.handle) · \(formatTimeAgo(from: comment.timestamp))"
        commentLabel.text = comment.text
        
        if let profileImageURL = comment.profileImageURL, let url = URL(string: profileImageURL) {
            profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            profileImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func formatTimeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
