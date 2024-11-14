//
//  ProfileView.swift
//  NeonSocialNetwork-APP
//
//  Created by Mert Palas on 10.11.2024.
//

import UIKit
import SnapKit
import NeonSDK

final class ProfileView: UIView {
    
    // NeonTableView Tanımı
    let tableView = NeonTableView<Post, PostTableViewCell>(objects: [], heightForRows: UITableView.automaticDimension)
    let profileHeaderView = ProfileHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        addSubview(tableView)
        
        // NeonTableView'in kenarlara sabitlenmesi
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // ProfileHeaderView'i NeonTableView'in başlık görünümü olarak ayarlıyoruz
        tableView.tableHeaderView = profileHeaderView
        tableView.tableHeaderView?.frame.size.height = 200
    }
}
