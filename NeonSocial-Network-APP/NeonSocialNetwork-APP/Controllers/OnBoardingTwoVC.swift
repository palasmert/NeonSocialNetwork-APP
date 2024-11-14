//
//  OnBoardingTwoViewController.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit

class OnBoardingPageTwoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    private let onboardingPageTwoView = OnBoardingPageTwoView()
    
    override func loadView() {
        self.view = onboardingPageTwoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    private func setupActions() {
        onboardingPageTwoView.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
    }
    
    @objc private func handleContinue() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
