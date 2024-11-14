//
//  HomeViewController.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 4.11.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import NeonSDK

class HomeViewController: UIViewController, UITabBarDelegate {
    
    // MARK: - Properties
    private let homeView = HomeView()
    private var posts: [Post] = [] // Gönderi listesi
    private var listeners: [ListenerRegistration] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeView()
        homeView.tabBar.delegate = self
        loadUserData()
        startListeningForPosts()

        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadTableView),
            name: Notification.Name("reloadPosts"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadPosts"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        homeView.tabBar.selectedItem = homeView.tabBar.items?[0]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Setup Methods
    
    private func setupHomeView() {
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        homeView.tabBar.delegate = self
        homeView.createPostButton.addTarget(self, action: #selector(createPostButtonTapped), for: .touchUpInside)
        
        homeView.customHeaderView.settingsButtonTapped = { [weak self] in
            self?.openSettings()
        }
        
        homeView.tableView.didSelect = { [weak self] post, indexPath in
            guard let self = self else { return }
            self.navigateToComments(for: post)
        }
    }
    
    // MARK: - Actions
    @objc private func createPostButtonTapped() {
        let postVC = PostViewController()
        postVC.modalPresentationStyle = .fullScreen
        present(postVC, animated: true)
    }
    
    private func openSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func reloadTableView() {
        homeView.tableView.objects = posts
    }
    
    // MARK: - Data Loading
    
    private func loadUserData() {
        ProfileManager.shared.fetchUserData { [weak self] userData in
            guard let self = self, let userData = userData else {
                print("Kullanıcı verisi alınamadı.")
                return
            }
            
            let userName = userData.username ?? "User"
            if let profileImageURL = userData.profileImageURL, let url = URL(string: profileImageURL) {
                self.loadImage(from: url) { image in
                    self.homeView.customHeaderView.configure(profileImage: image, userName: userName)
                }
            } else {
                self.homeView.customHeaderView.configure(profileImage: nil, userName: userName)
            }
        }
    }
    private func navigateToComments(for post: Post) {
        let commentVC = CommentViewController()
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
    
    private func startListeningForPosts() {
        let db = Firestore.firestore()
        db.collection("posts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error listening for posts updates: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found in 'posts' collection.")
                    return
                }
                
                let currentUserID = Auth.auth().currentUser?.uid ?? ""
                self.posts = documents.compactMap { doc -> Post? in
                    let data = doc.data()
                    let likedBy = data["likedBy"] as? [String] ?? []
                    let isLiked = likedBy.contains(currentUserID)
                    
                    return Post(
                        id: doc.documentID,
                        profileImageURL: data["profileImageURL"] as? String,
                        username: data["username"] as? String ?? "",
                        handle: data["handle"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        nickName: data["nickName"] as? String ?? "",
                        text: data["text"] as? String ?? "",
                        likeCount: data["likeCount"] as? Int ?? 0,
                        commentCount: data["commentCount"] as? Int ?? 0,
                        postImageURL: data["postImageURL"] as? String,
                        userID: data["userID"] as? String ?? "",
                        likedBy: likedBy,
                        isLiked: isLiked
                    )
                }
                
                self.homeView.tableView.objects = self.posts
            }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            switch item.tag {
            case 0:
                // Home ekranına geçiş yapılıyor
                if !(navigationController?.topViewController is HomeViewController) {
                    navigationController?.popToRootViewController(animated: true)
                }
                
            case 2:
                // Profile ekranına geçiş yapılıyor
                let profileVC = ProfileViewController()
                navigationController?.pushViewController(profileVC, animated: true)
                
            default:
                break
            }
        }
    
    private func removeListeners() {
        listeners.forEach { $0.remove() }
        listeners.removeAll()
    }
}
extension HomeViewController: PostCellDelegate {
    
    func postCellDidToggleLikeButton(_ cell: PostTableViewCell, isLiked: Bool) {
        guard let indexPath = homeView.tableView.indexPath(for: cell) else { return }
        
        var post = posts[indexPath.row]
        let currentUserID = Auth.auth().currentUser?.uid ?? ""
        
        if isLiked {
            post.likedBy.append(currentUserID)
            post.likeCount += 1
        } else {
            post.likedBy.removeAll { $0 == currentUserID }
            post.likeCount = max(post.likeCount - 1, 0)
        }
        
        posts[indexPath.row] = post
        homeView.tableView.reloadRows(at: [indexPath], with: .none)
        
        let db = Firestore.firestore()
        let postRef = db.collection("posts").document(post.id ?? "")
        postRef.updateData([
            "likeCount": post.likeCount,
            "likedBy": post.likedBy
        ]) { error in
            if let error = error {
                print("Beğeni güncelleme hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func postCellDidTapCommentButton(_ cell: PostTableViewCell) {
        // Yorum ekranına geçiş için yapılacak işlemler
        guard let indexPath = homeView.tableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        
        let commentVC = CommentViewController()
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
}
