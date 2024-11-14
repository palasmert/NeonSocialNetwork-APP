//
//  OnBoardingView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit
import SnapKit

class OnboardingView: UIView {

    // MARK: - UI Elements
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()

    let firstLineLabel: UILabel = {
        let label = UILabel()
        label.text = "A social has"
        label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    let secondLineLabel: UILabel = {
        let label = UILabel()
        label.text = "never been so"
        label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    let highlightLabel: UILabel = {
        let label = UILabel()
        label.text = "Sustainable"
        label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Share Your Eco-friendly Journey,\nFollow Sustainable Influencers, and\nInspire Others to Make a Difference"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo_placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        [firstLineLabel, secondLineLabel, highlightLabel].forEach { titleStackView.addArrangedSubview($0) }
        [titleStackView, descriptionLabel, logoImageView, continueButton].forEach { addSubview($0) }

        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(60)
            make.left.right.equalToSuperview().inset(30)
        }

        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }

        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(70)
            make.width.equalTo(150)
        }
    }
}
