//
//  ProfileHeaderVC.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 6.11.2024.
//
 
import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import NeonSDK

class ProfileViewController: UIViewController {
    // MARK: - Properties
    private let profileHeaderView = ProfileHeaderView()
    
    // NeonTableView Tanımı
    private let tableView = NeonTableView<Post, PostTableViewCell>(objects: [], heightForRows: UITableView.automaticDimension)
    private var posts: [Post] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadUserData()
        fetchUserPosts()
        
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        view.addSubview(tableView)
        
        // NeonTableView Özellikleri
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // ProfileHeaderView'i tableHeaderView olarak ayarla
        profileHeaderView.frame.size.height = 200
        tableView.tableHeaderView = profileHeaderView
        
        tableView.didSelect = { [weak self] post, indexPath in
            guard let self = self else { return }
            self.navigateToComments(for: post)
        }
    }
    // MARK: - Data Fetching
    private func loadUserData() {
        fetchUserData { [weak self] userData in
            guard let self = self, let userData = userData else {
                print("Kullanıcı verisi alınamadı.")
                return
            }
            
            // `profileHeaderView`'i kullanıcı verileriyle yapılandır
            DispatchQueue.main.async {
                self.profileHeaderView.configure(
                    profileImageURL: userData.profileImageURL,
                    username: "@\(userData.nickName ?? "")",
                    bio: userData.bio,
                    postsCount: userData.postCount ?? 0,
                    followersCount: userData.followersCount ?? 0,
                    followingCount: userData.followingCount ?? 0
                )
            }
        }
    }
    
    private func fetchUserData(completion: @escaping (UserData?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Kullanıcı kimliği bulunamadı.")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Kullanıcı verisi alınamadı: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Veri bulunamadı.")
                completion(nil)
                return
            }
            
            // Firestore'dan alınan verileri UserData modeline göre ayarlama
            let userData = UserData(
                uid: userID,
                email: data["email"] as? String,
                username: data["username"] as? String,
                nickName: data["nickName"] as? String,
                profileImageURL: data["profileImageURL"] as? String,
                bio: data["bio"] as? String,
                followersCount: data["followersCount"] as? Int,
                followingCount: data["followingCount"] as? Int,
                postCount: data["postCount"] as? Int
            )
            
            completion(userData)
        }
    }
    
    private func fetchUserPosts() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        PostManager.shared.fetchPostsForUser(userID: currentUserID) { [weak self] posts in
            self?.posts = posts
            
            // NeonTableView'e verileri doğrudan ata
            DispatchQueue.main.async {
                self?.tableView.objects = posts
            }
        }
    }
    
    private func navigateToComments(for post: Post) {
           let commentVC = CommentViewController()
           commentVC.post = post
           navigationController?.pushViewController(commentVC, animated: true)
       }
}

// MARK: - PostCellDelegate
extension ProfileViewController: PostCellDelegate {
    
    func postCellDidToggleLikeButton(_ cell: PostTableViewCell, isLiked: Bool) {
        // tableView yerine profileView.tableView kullanılıyor
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var post = posts[indexPath.row]
        
        // `PostManager` sınıfındaki `toggleLike` fonksiyonunu kullanarak beğeni durumunu güncelle
        PostManager.shared.toggleLike(for: post.id ?? "") { [weak self] success in
            guard success else { return }
            
            // Beğeni durumu güncellendikten sonra `posts` dizisindeki veriyi güncelle
            post.isLiked.toggle()
            post.likeCount += post.isLiked ? 1 : -1
            self?.posts[indexPath.row] = post
            
            // `profileView.tableView`'in ilgili hücresini güncelle
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func postCellDidTapCommentButton(_ cell: PostTableViewCell) {
        // tableView yerine profileView.tableView kullanılıyor
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        
        let commentVC = CommentViewController()
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
}
