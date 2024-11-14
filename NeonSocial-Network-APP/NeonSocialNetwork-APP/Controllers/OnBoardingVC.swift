//
//  ViewController.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit

class OnboardingViewController: UIViewController {

    private let onboardingView = OnboardingView()

    override func loadView() {
        self.view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    private func setupActions() {
        onboardingView.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
    }

    @objc private func handleContinue() {
        let onboardingPageTwoVC = OnBoardingPageTwoViewController()
        
        navigationController?.pushViewController(onboardingPageTwoVC, animated: true)
        
    }
}
