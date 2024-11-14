//
//  SettingsViewController.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 4.11.2024.
//
import UIKit
import NeonSDK
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    private let settingsView = SettingsView()
    
    // Ayarlar Menüsü Seçenekleri
    private let settingsTitles = [
        ("Share app", "square.and.arrow.up.fill"),
        ("Rate us", "star.fill"),
        ("Contact us", "envelope.fill"),
        ("Terms of Use", "questionmark.circle.fill"),
        ("Privacy policy", "shield.fill"),
        ("Restore Purchase", "arrow.counterclockwise.circle.fill"),
        ("Account Settings", "person.fill"),
        ("Log Out", "arrow.backward.square.fill")
    ]

    private let tableView = NeonTableView<(String, String), SettingsTableViewCell> (
        objects: [],
        heightForRows: 70
    )
    
    override func loadView() {
        self.view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        setupTableView()
    }
    
    private func setupTableView() {
        settingsView.addSubview(tableView)
        tableView.objects = settingsTitles
        tableView.snp.makeConstraints { make in
            tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
            tableView.didSelect = { [weak self] setting, indexPath in
                        guard let self = self else { return }
                        print("Hücreye tıklandı: \(setting.0)")  // Tıklama olayını kontrol ediyoruz
                        self.handleSelection(setting.0)
                    }
        }
    }
    private func handleSelection(_ setting: String) {
            if setting == "Log Out" {
                let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
                    self?.logOutUser() 
                }))
                present(alert, animated: true, completion: nil)
            } else {
                print("\(setting) seçildi")
            }
        }
    
    private func logOutUser() {
        do {
            try Auth.auth().signOut()
            navigateToOnboardingScreen()
        } catch let signOutError as NSError {
            let alert = UIAlertController(title: "Error", message: "Failed to log out. Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func navigateToOnboardingScreen() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        let onboardingViewController = OnboardingViewController()
        let navController = UINavigationController(rootViewController: onboardingViewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}
