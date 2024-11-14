//
//  LoginVC.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        navigationItem.hidesBackButton = true
    }
    
    private func setupActions() {
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(navigateToSignUp), for: .touchUpInside)
    }
    
    @objc private func handleLogin() {
        // E-posta ve şifre ile giriş (örnek)
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            print("Email ve şifre boş bırakılamaz.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Giriş yapılırken hata oluştu: \(error.localizedDescription)")
                return
            }
            UserDefaults.standard.set(true, forKey: "isUserSignup")
            self?.navigateToHome()
        }
    }
    
    @objc private func navigateToSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func navigateToHome() {
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = navigationController
        }
    }
}
