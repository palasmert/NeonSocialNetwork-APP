//
//  CommentViewController.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 6.11.2024.
//

import UIKit
import SDWebImage

class CommentViewController: UIViewController {
    
    var post: Post?
    private var comments: [Comment] = []

    private let commentHeaderView = CommentHeaderView() // Yorum başlığı
    private let tableView = UITableView() // Yorumların gösterildiği tablo
    private let sendButton = UIButton(type: .system) // Gönder butonu

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserProfileImage()
        loadComments()
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(commentHeaderView)
        view.addSubview(tableView)
        view.addSubview(sendButton)
        
        setupConstraints()
        setupTableView()
    }

    private func setupConstraints() {
        commentHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(commentHeaderView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(sendButton.snp.top)
        }

        sendButton.setTitle("Send", for: .normal)
        sendButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(50)
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    private func loadUserProfileImage() {
        guard let currentUser = ProfileManager.shared.getUser() else { return }
        commentHeaderView.configure(with: currentUser.profileImageURL)
    }

    private func loadComments() {
        guard let postID = post?.id else { return }
        PostManager.shared.fetchComments(for: postID) { [weak self] comments in
            self?.comments = comments
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc private func didTapSendButton() {
        guard let postID = post?.id,
              let commentText = commentHeaderView.commentText,
              !commentText.isEmpty else {
            return
        }
        
        PostManager.shared.addComment(to: postID, commentText: commentText) { [weak self] success in
            if success {
                self?.loadComments()
                self?.commentHeaderView.clearTextField()
            }
        }
    }
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}
