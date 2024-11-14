//
//  SignUpView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 3.11.2024.
//

import UIKit
import SnapKit

class SignUpView: UIView {
    
    // MARK: - UI Elements
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.badge.plus")
        imageView.backgroundColor = UIColor.systemGray6
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
        
    let signupButton: CustomButton = {
        let button = CustomButton()
        button.configureButton(withTitle: "Sign Up", titleColor: .black, fontSize: 20, backgroundColor: .systemGray6)
        return button
    }()
    
    let alreadyHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let loginButton: UIButton = {
          let button = UIButton(type: .system)
          let attributedString = NSAttributedString(
              string: "Login",
              attributes: [
                  .underlineStyle: NSUnderlineStyle.single.rawValue,
                  .foregroundColor: UIColor.systemGreen,
                  .font: UIFont.systemFont(ofSize: 16)
              ]
          )
          button.setAttributedTitle(attributedString, for: .normal)
          return button
      }()
    
    let usernameTextField = UITextField().configurePlaceholder("Username")
    let nicknameTextField = UITextField().configurePlaceholder("Nickname")
    let emailTextField = UITextField().configurePlaceholder("Mail")
    let passwordTextField = UITextField().configurePlaceholder("Password", isSecure: true)
    let aboutMeTextField = UITextField().configurePlaceholder("About Me")
    
    // Stack view to hold text fields
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, nicknameTextField, emailTextField, passwordTextField, aboutMeTextField])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        // Social buttons stack view oluştur
        let socialButtonsStackView = createSocialButtonsStackView()
        
        // UI bileşenlerini ekle
        [signUpLabel, profileImageView, textFieldStackView, orLabel, socialButtonsStackView, alreadyHaveAccountLabel, loginButton, signupButton].forEach { addSubview($0) }
        
        // Constraint'leri tanımla
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(40)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(signUpLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().offset(0)
        }
        
        orLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        socialButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        alreadyHaveAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(socialButtonsStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(alreadyHaveAccountLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        signupButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.width.equalTo(150)
            make.height.equalTo(70)
        }
        
        // UI elementlerine ek özellikleri uygula
        addUnderlines() // Alt çizgileri ekle
        addHorizontalLines(around: orLabel) // orLabel çevresine çizgileri ekle
        addPaddingToTextFields()
    }
    
    // MARK: - Add underline to text fields
    private func addUnderlines() {
        [usernameTextField, nicknameTextField, emailTextField, passwordTextField, aboutMeTextField].forEach { $0.setUnderlined() }
    }
    
    private func addPaddingToTextFields() {
        [usernameTextField, nicknameTextField, emailTextField, passwordTextField, aboutMeTextField].forEach { $0.setLeftPadding(30) }
    }
}
