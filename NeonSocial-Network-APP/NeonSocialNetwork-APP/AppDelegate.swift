//
//  AppDelegate.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 2.11.2024.
//

import UIKit
import NeonSDK
import FirebaseCore


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        FirebaseApp.configure()
  
        if AuthManager.currentUserID == nil {
            let onboardingViewController = OnboardingViewController()
            let navController = UINavigationController(rootViewController: onboardingViewController)
            Neon.configure(window: &window, onboardingVC: onboardingViewController, paywallVC: navController, homeVC: navController)
            window?.rootViewController = navController
        } else {
            let homeVC = HomeViewController()
            window?.rootViewController = homeVC
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}

