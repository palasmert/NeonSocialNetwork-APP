//
//  HomeView.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 4.11.2024.
//

import UIKit
import SnapKit
import NeonSDK

class HomeView: UIView {
    
    let customHeaderView = CustomHeaderView()
    let tabBar = UITabBar()
    let createPostButton = CustomButton()
    let tableView = NeonTableView<Post, PostTableViewCell>(objects: [], heightForRows: UITableView.automaticDimension)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        setupHeaderView()
        setupTableView()
        setupTabBar()
        setupCreatePostButton()
    }
    
    private func setupTableView() {
         addSubview(tableView)
         
         tableView.snp.makeConstraints { make in
             make.top.equalTo(customHeaderView.snp.bottom)
             make.left.right.equalToSuperview()
             make.centerY.equalTo(safeAreaLayoutGuide)
         }
     }
    
    private func setupHeaderView() {
        addSubview(customHeaderView)
        
        // Header View constraint'leri
        customHeaderView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        // Kullanıcı bilgileriyle header'ı yapılandırma
        customHeaderView.configure(profileImage: UIImage(named: "palasImage"), userName: "Sophie")
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        
        // Tab bar itemlarını ekleyelim
        let homeItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let networkItem = UITabBarItem(title: "Network", image: UIImage(systemName: "person.2"), tag: 1)
        let profileItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        
        tabBar.items = [homeItem, networkItem, profileItem]
        tabBar.selectedItem = homeItem
        
        addSubview(tabBar)
        
        // TabBar constraint'leri
        tabBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(60)
        }
    }
    
    private func setupCreatePostButton() {
        // Create Post butonunu ekleyelim
        addSubview(createPostButton)
        createPostButton.configureButton(withTitle: "Create Post", fontSize: 18, backgroundColor: .systemGreen)
        
        // Create Post Button constraint'leri
        createPostButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top).offset(-16) // Tab bar'ın üstünde olacak şekilde konumlandırıyoruz
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }
}
