//
//  CustomHeaderView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 4.11.2024.
//

import UIKit
import SnapKit

class CustomHeaderView: UIView {
    
    // MARK: - Closure
    var settingsButtonTapped: (() -> Void)?
    
    // MARK: - UI Elements
     let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.crop.circle")
        return imageView
    }()
    
     let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, User"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
     let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white
        [profileImageView, helloLabel, settingsButton].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        helloLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(12)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
    }
    
    private func setupActions() {
        settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
    }
    
    @objc private func didTapSettingsButton() {
        settingsButtonTapped?() // Closure çağrılıyor
    }
    
    func configure(profileImage: UIImage?, userName: String) {
        profileImageView.image = profileImage ?? UIImage(systemName: "person.crop.circle")
        helloLabel.text = "Hello, \(userName)"
        
        print("configure çağrıldı - Kullanıcı Adı:", helloLabel.text ?? "")
    }
}
