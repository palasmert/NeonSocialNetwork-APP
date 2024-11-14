//
//  CommentView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 6.11.2024.
//

import UIKit
import SnapKit

class CommentHeaderView: UIView {
    
    let profileImageView = UIImageView()
    private let commentTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(commentTextField)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        commentTextField.placeholder = "Send your comment!"
        commentTextField.font = UIFont.systemFont(ofSize: 16)
        commentTextField.borderStyle = .none
        commentTextField.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with profileImageURL: String?) {
        if let urlString = profileImageURL, let url = URL(string: urlString) {
            profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    var commentText: String? {
        return commentTextField.text
    }
    
    func clearTextField() {
        commentTextField.text = ""
    }
}
