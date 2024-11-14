//
//  PostView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 6.11.2024.
//

import UIKit
import SnapKit
import NeonSDK

protocol PostViewDelegate: AnyObject {
    func didTapBackButton()
    func didTapAddImageButton()
    func didTapShareButton(with text: String)
}

class PostView: UIView {
    
    let profileImageView = UIImageView()
    let postTextView = NeonTextView() // Düzenlendi
    let addImageButton = UIButton(type: .system)
    let shareButton = UIButton(type: .system)
    let postImageView = UIImageView()

    weak var delegate: PostViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        // Üst Bar
        let topBarView = UIView()
        addSubview(topBarView)
        
        topBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        // Geri Butonu
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        topBarView.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        // İptal Butonu
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        topBarView.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        // Profil Resmi
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        
        postTextView.placeholder = "Enter your windom..."
        postTextView.font = UIFont.systemFont(ofSize: 16)
        addSubview(postTextView)
        
        postTextView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }
        
        // Post Image View (Seçili resmi göstermek için)
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 8
        postImageView.isHidden = true // Başlangıçta gizli
        addSubview(postImageView)
        
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(postTextView.snp.bottom).offset(64)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(200)
        }
        
        // "+" Butonu
        addImageButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addImageButton.tintColor = .lightGray
        addImageButton.addTarget(self, action: #selector(didTapAddImage), for: .touchUpInside)
        addSubview(addImageButton)
        
        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        // Paylaş Butonu
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = UIColor.systemGreen
        shareButton.layer.cornerRadius = 5
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        addSubview(shareButton)
        
        shareButton.snp.makeConstraints { make in
            make.centerY.equalTo(addImageButton)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    @objc private func didTapAddImage() {
        delegate?.didTapAddImageButton()
    }
    
    @objc private func didTapShare() {
        guard let text = postTextView.text, !text.isEmpty else { return }
        delegate?.didTapShareButton(with: text)
    }
    
    @objc private func didTapBack() {
        delegate?.didTapBackButton()
    }
    
    // Seçilen resmi postImageView'de göstermek için bir fonksiyon
    func setPostImage(_ image: UIImage?) {
        if let image = image {
            postImageView.image = image
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
}
