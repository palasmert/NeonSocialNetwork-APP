//
//  Apple-googleExt.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 4.11.2024.
//

import UIKit
import SnapKit

extension UIView {
    func createSocialButtonsStackView() -> UIStackView {
        let googleButton = UIButton(type: .system)
        googleButton.setImage(UIImage(named: "google_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        googleButton.imageView?.contentMode = .scaleAspectFit
        googleButton.backgroundColor = UIColor.systemGray6
        googleButton.clipsToBounds = true
        googleButton.layer.cornerRadius = 8
        googleButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        let appleButton = UIButton(type: .system)
        appleButton.setImage(UIImage(named: "apple_logo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        appleButton.imageView?.contentMode = .scaleAspectFit
        appleButton.backgroundColor = UIColor.systemGray6
        appleButton.clipsToBounds = true
        appleButton.layer.cornerRadius = 8
        appleButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }

        let buttonStackView = UIStackView(arrangedSubviews: [googleButton, appleButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 30
        buttonStackView.alignment = .center
        buttonStackView.distribution = .equalSpacing

        return buttonStackView
    }
}
