//
//  LoginView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit
import SnapKit

class LoginView: UIView {
    // MARK: - UI Elements
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mail"
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()

    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSAttributedString(
            string: "Forgot Password?",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()

    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account yet?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSAttributedString(
            string: "sign up",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.systemGreen,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()

    let loginButton: CustomButton = {
        let button = CustomButton()
        button.configureButton(withTitle: "Continue", titleColor: .black, fontSize: 20, backgroundColor: .systemGray6)
        return button
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        emailTextField.setUnderlined()
        passwordTextField.setUnderlined()
        addHorizontalLines(around: orLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        emailTextField.setUnderlined()
        passwordTextField.setUnderlined()
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white

        // Google ve Apple butonlarını extension ile oluştur
        let buttonStackView = createSocialButtonsStackView()
        addSubview(buttonStackView)

        // Sign up etiketi ve buton için stack view oluştur
        let signUpStackView = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
        signUpStackView.axis = .vertical
        signUpStackView.spacing = 2
        signUpStackView.alignment = .center
        addSubview(signUpStackView)

        // Subview'ları ekleyin
        [loginLabel, emailTextField, passwordTextField, forgotPasswordButton, orLabel, buttonStackView, signUpStackView, loginButton].forEach { addSubview($0) }

        // Constraint'leri tanımlayın
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(40)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.right.equalTo(passwordTextField.snp.right)
        }

        orLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(20)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        signUpStackView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.width.equalTo(150)
            make.height.equalTo(70)
        }
    }
}
