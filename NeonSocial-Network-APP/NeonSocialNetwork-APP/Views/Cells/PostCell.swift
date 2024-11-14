//
//  PostCell.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 4.11.2024.
//

import UIKit
import SnapKit
import NeonSDK
import SDWebImage

protocol PostCellDelegate: AnyObject {
    func postCellDidTapCommentButton(_ cell: PostTableViewCell)
    func postCellDidToggleLikeButton(_ cell: PostTableViewCell, isLiked: Bool)
}

class PostTableViewCell: NeonTableViewCell<Post> {
    static let identifier = "PostCell"
    weak var delegate: PostCellDelegate?
    
    // UI bileşenleri
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let handleLabel = UILabel()
    private let timeAgoLabel = UILabel()
    private let postTextLabel = UILabel()
    private let postImageView = UIImageView()
    private let likeButton = UIButton()
    private let commentButton = UIButton()
    private let likeCountLabel = UILabel()
    private let commentCountLabel = UILabel()
    
    private var post: Post?
    var isLiked: Bool = false {
        didSet { updateLikeButtonAppearance() }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // configure(with:) metodunu `NeonTableView` ile uyumlu hale getirme
    override func configure(with post: Post) {
        self.post = post
        setupCommonData(with: post)
        postTextLabel.font = UIFont.systemFont(ofSize: 18)
        configurePostImageView(with: post.postImageURL)
        isLiked = post.isLiked
        updateLikeButtonAppearance()
    }
    
    private func setupUI() {
        setupProfileImageView()
        setupLabels()
        setupButtons()
        setupPostImageView()
        setupConstraints()
    }
    
    private func setupActions() {
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
    }
    
    @objc private func didTapLikeButton() {
        isLiked.toggle()
        delegate?.postCellDidToggleLikeButton(self, isLiked: isLiked)
        updateLikeButtonAppearance()
    }
    
    private func updateLikeButtonAppearance() {
        let imageName = isLiked ? "heart.fill" : "heart"
        let tintColor = isLiked ? UIColor.red : UIColor.gray
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.tintColor = tintColor
       
        if let likeCount = post?.likeCount {
                  likeCountLabel.text = "\(isLiked ? likeCount + 1 : likeCount)"
              }
    }
    
    @objc private func didTapCommentButton() {
        delegate?.postCellDidTapCommentButton(self)
    }
    
    private func setupCommonData(with post: Post) {
        usernameLabel.text = post.username
        handleLabel.text = "@\(post.handle)"
        timeAgoLabel.text = formatDate(post.timestamp)
        postTextLabel.text = post.text
        likeCountLabel.text = "\(post.likeCount)"
        commentCountLabel.text = "\(post.commentCount)"
        
        // Profil görselini ayarla
        if let profileImageUrlString = post.profileImageURL, let profileImageUrl = URL(string: profileImageUrlString) {
            profileImageView.sd_setImage(with: profileImageUrl, placeholderImage: UIImage(named: "placeholder"))
        } else {
            profileImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func configurePostImageView(with imageUrlString: String?) {
        if let postImageUrlString = imageUrlString, let postImageUrl = URL(string: postImageUrlString) {
            postImageView.sd_setImage(with: postImageUrl, placeholderImage: UIImage(named: "placeholder"))
            postImageView.isHidden = false
            
            postImageView.snp.remakeConstraints { make in
                make.top.equalTo(handleLabel.snp.bottom).offset(4)
                make.right.equalToSuperview().offset(-16)
                make.width.height.equalTo(150)
            }
            
            postTextLabel.snp.remakeConstraints { make in
                make.top.equalTo(handleLabel.snp.bottom).offset(16)
                make.left.equalTo(profileImageView)
                make.right.equalTo(postImageView.snp.left).offset(-16)
            }
            
        } else {
            postImageView.isHidden = true
            postImageView.snp.remakeConstraints { make in
                make.top.equalTo(postTextLabel.snp.bottom).offset(0)
                make.height.equalTo(0)
            }
            
            postTextLabel.snp.remakeConstraints { make in
                make.top.equalTo(handleLabel.snp.bottom).offset(16)
                make.left.equalTo(profileImageView)
                make.right.equalToSuperview().offset(-16)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        contentView.addSubview(profileImageView)
    }
    
    private func setupLabels() {
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        handleLabel.font = UIFont.systemFont(ofSize: 14)
        handleLabel.textColor = .gray
        postTextLabel.numberOfLines = 0
        timeAgoLabel.font = UIFont.systemFont(ofSize: 12)
        timeAgoLabel.textColor = .lightGray
        likeCountLabel.font = UIFont.systemFont(ofSize: 14)
        likeCountLabel.textColor = .gray
        commentCountLabel.font = UIFont.systemFont(ofSize: 14)
        commentCountLabel.textColor = .gray
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(handleLabel)
        contentView.addSubview(postTextLabel)
        contentView.addSubview(timeAgoLabel)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(commentCountLabel)
    }
    
    private func setupButtons() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        commentButton.tintColor = .gray
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
    }
    
    private func setupPostImageView() {
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 12
        contentView.addSubview(postImageView)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.lessThanOrEqualTo(timeAgoLabel.snp.left).offset(-8)
        }

        handleLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(2)
            make.left.equalTo(usernameLabel)
        }

        timeAgoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        postTextLabel.snp.makeConstraints { make in
            make.top.equalTo(handleLabel.snp.bottom).offset(8)
            make.left.equalTo(profileImageView)
            make.right.equalToSuperview().offset(-16)
        }

        postImageView.snp.makeConstraints { make in
            make.top.equalTo(postTextLabel.snp.bottom).offset(8)
            make.left.equalTo(postTextLabel.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(0)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.left.equalTo(postTextLabel)
            make.width.height.equalTo(20)
        }

        likeCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeButton.snp.right).offset(4)
        }

        commentButton.snp.makeConstraints { make in
                    make.centerY.equalTo(likeButton)
                    make.left.equalTo(likeCountLabel.snp.right).offset(16)
                    make.width.height.equalTo(20)
                }

                commentCountLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(commentButton)
                    make.left.equalTo(commentButton.snp.right).offset(4)
                }

                let bottomSpace = UIView()
                contentView.addSubview(bottomSpace)
                bottomSpace.snp.makeConstraints { make in
                    make.top.equalTo(likeButton.snp.bottom).offset(16)
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(8)
                }
            }
        }
