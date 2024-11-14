//
//  SettingsCell.swift
//  NeonSocialNetwork-APP
//
//  Created by Mert Palas on 14.11.2024.
//

import UIKit
import NeonSDK

class SettingsTableViewCell: NeonTableViewCell<(String, String)> {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    override func configure(with object: (String, String)) {
        titleLabel.text = object.0
        iconImageView.image = UIImage(systemName: object.1)
        
        // "Log Out" seçeneği için özel renklendirme
        if object.0 == "Log Out" {
            iconImageView.tintColor = .systemRed
            titleLabel.textColor = .systemRed
        } else {
            iconImageView.tintColor = .systemGreen
            titleLabel.textColor = .black
        }
    }
}
