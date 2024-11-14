//
//  ProfileHeaderView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 6.11.2024.
//

import UIKit
import SnapKit

final class ProfileHeaderView: UIView {
    
    // MARK: - Properties
    private let profileImageView = UIImageView()
    private let nickNameLabel = UILabel()
    private let bioLabel = UILabel()
    private let postsCountLabel = UILabel()
    private let followersCountLabel = UILabel()
    private let followingCountLabel = UILabel()
    private let postsLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    private let statsStackView = UIStackView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        addSubview(profileImageView)
        
        // İstatistik sayıları
        [postsCountLabel, followersCountLabel, followingCountLabel].forEach { label in
            label.font = .boldSystemFont(ofSize: 16)
            label.textAlignment = .center
            label.text = "0" // Varsayılan değer
        }
        
        // İstatistik açıklama metinleri
        postsLabel.text = "Posts"
        followersLabel.text = "Followers"
        followingLabel.text = "Following"
        
        [postsLabel, followersLabel, followingLabel].forEach { label in
            label.font = .systemFont(ofSize: 12)
            label.textColor = .gray
            label.textAlignment = .center
        }
        
        // İstatistik stackview
        setupStatsStackView()
        
        nickNameLabel.font = .systemFont(ofSize: 14)
        nickNameLabel.textColor = .gray
        nickNameLabel.textAlignment = .left
        addSubview(nickNameLabel)
        
        bioLabel.font = .systemFont(ofSize: 14)
        bioLabel.textColor = .darkGray
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .left
        addSubview(bioLabel)
    }
    
    private func setupStatsStackView() {
        let postsStack = UIStackView(arrangedSubviews: [postsCountLabel, postsLabel])
        postsStack.axis = .vertical
        postsStack.alignment = .center
        
        let followersStack = UIStackView(arrangedSubviews: [followersCountLabel, followersLabel])
        followersStack.axis = .vertical
        followersStack.alignment = .center
        
        let followingStack = UIStackView(arrangedSubviews: [followingCountLabel, followingLabel])
        followingStack.axis = .vertical
        followingStack.alignment = .center
        
        statsStackView.axis = .horizontal
        statsStackView.alignment = .center
        statsStackView.distribution = .equalSpacing
        statsStackView.spacing = 16
        statsStackView.addArrangedSubview(postsStack)
        statsStackView.addArrangedSubview(followersStack)
        statsStackView.addArrangedSubview(followingStack)
        addSubview(statsStackView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(70)
        }
        
        statsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.left.equalTo(profileImageView)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(4)
            make.left.equalTo(profileImageView)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Configure Function
    func configure(profileImageURL: String?, username: String?, bio: String?, postsCount: Int, followersCount: Int, followingCount: Int) {
        
        if let profileImageURL = profileImageURL, let url = URL(string: profileImageURL) {
            loadImage(from: url) { [weak self] image in
                self?.profileImageView.image = image
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle") // Varsayılan bir görsel
        }
        
        nickNameLabel.text = username ?? "@username"
        bioLabel.text = bio ?? "Bio not available"
        postsCountLabel.text = "\(postsCount)"
        followersCountLabel.text = "\(followersCount)"
        followingCountLabel.text = "\(followingCount)"
    }
    
    // MARK: - Image Loading Helper
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
