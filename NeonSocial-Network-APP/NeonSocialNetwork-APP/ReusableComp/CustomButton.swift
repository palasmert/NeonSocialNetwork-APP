//
//  CustomButton.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit

class CustomButton: UIButton {

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    // Button Özelliklerini Ayarlama
    private func setupButton() {
        self.tintColor = .white
        self.layer.cornerRadius = 20
    }

    // Başlığı, rengi, boyutu ve arka plan rengini ayarlamak için bir fonksiyon
    func configureButton(withTitle title: String, titleColor: UIColor = .white, fontSize: CGFloat = 16, backgroundColor: UIColor = .systemGreen) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        self.backgroundColor = backgroundColor
    }
}
