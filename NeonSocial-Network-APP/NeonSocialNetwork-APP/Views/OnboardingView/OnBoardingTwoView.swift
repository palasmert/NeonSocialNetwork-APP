//
//  OnBoardingTwoView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit

class OnBoardingPageTwoView: UIView {

    // MARK: - UI Elements
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore Sustainable Practices\nand Inspiring Stories"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let highlightedTextLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(
            string: "The\npurposeful all-in-1\nsocial; network,\npublish, discuss,\nimpact",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 28),
                .foregroundColor: UIColor.black
            ]
        )
        attributedText.addAttribute(
            .foregroundColor, value: UIColor.systemGreen, range: NSRange(location: 4, length: 20)
        )
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let continueButton: CustomButton = {
        let button = CustomButton()
        button.configureButton(withTitle: "Continue", titleColor: .white, fontSize: 20, backgroundColor: .systemGreen)
        return button
    }()
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white
        [headerLabel, highlightedTextLabel, continueButton].forEach { addSubview($0) }

        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        highlightedTextLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(120)
            make.left.right.equalToSuperview().inset(20)
        }

        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(70)
            make.width.equalTo(150)
        }
    }

}
