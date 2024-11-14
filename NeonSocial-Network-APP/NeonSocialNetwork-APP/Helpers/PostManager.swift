//
//  PostManager.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 7.11.2024.
//

import FirebaseFirestore
import FirebaseAuth
import NeonSDK

// PostManager sınıfı, gönderi ve yorum yönetimi işlevlerini içerir.
class PostManager {
    static let shared = PostManager() // Singleton olarak sınıfın tek bir örneği oluşturuluyor
    private let db = Firestore.firestore() // Firestore veritabanı referansı
    
    var posts: [Post] = [] // Tüm gönderilerin tutulduğu dizi
    
    
    func addComment(to postID: String, commentText: String, completion: @escaping (Bool) -> Void) {
        guard let _ = AuthManager.currentUserID, // userID'yi kullanmayacağımız için "_" ile değiştirdik
              let username = Auth.auth().currentUser?.displayName,
              let nickName = ProfileManager.shared.getUser()?.nickName else {
            completion(false)
            return
        }
        let comment = Comment(
            username: username,
            handle: "@\(nickName)",
            text: commentText,
            timestamp: Date(),
            profileImageURL: Auth.auth().currentUser?.photoURL?.absoluteString ?? ""
        )
        FirestoreManager.setDocument(
            path: [
                .collection(name: "posts"),
                .document(name: postID),
                .collection(name: "comments"),
                .document(name: UUID().uuidString)
            ],
            object: comment
        )
        // Yorum sayısını güncelleme
        FirestoreManager.updateDocument(
            path: [
                .collection(name: "posts"),
                .document(name: postID)
            ],
            fields: ["commentCount": FieldValue.increment(Int64(1))]
        )
        completion(true)
    }

    
    // MARK: - Yorum Ekleme Fonksiyonu
//    func addComment(to postID: String, commentText: String, completion: @escaping (Bool) -> Void) {
//        guard let userID = Auth.auth().currentUser?.uid,
//              let username = Auth.auth().currentUser?.displayName,
//              let nickName = ProfileManager.shared.getUser()?.nickName else {
//            completion(false)
//            return
//        }
//        
//        let commentData: [String: Any] = [
//            "userID": userID,
//            "username": username,
//            "handle": "@\(nickName)",
//            "text": commentText,
//            "timestamp": Timestamp(date: Date()),
//            "profileImageURL": Auth.auth().currentUser?.photoURL?.absoluteString ?? ""
//        ]
//        
//        let postRef = db.collection("posts").document(postID)
//        postRef.collection("comments").addDocument(data: commentData) { error in
//            if let error = error {
//                print("Error adding comment: \(error)")
//                completion(false)
//            } else {
//                postRef.updateData(["commentCount": FieldValue.increment(Int64(1))]) { error in
//                    if let error = error {
//                        print("Error updating comment count: \(error)")
//                    }
//                }
//                completion(true)
//            }
//        }
//    }
    
   //  MARK: - Yorumları Alma Fonksiyonu
    func fetchComments(for postID: String, completion: @escaping ([Comment]) -> Void) {
        // Belirtilen gönderinin "comments" koleksiyonuna erişim sağlıyoruz
        db.collection("posts").document(postID).collection("comments")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Error fetching comments: \(error!)")
                    completion([]) // Hata varsa dizi boş döner
                    return
                }

                // Firestore belgelerini `Comment` nesnelerine dönüştürüyoruz
                let comments = documents.compactMap { doc -> Comment? in
                    let data = doc.data()
                    return Comment(
                        username: data["username"] as? String ?? "",
                        handle: data["handle"] as? String ?? "",
                        text: data["text"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        profileImageURL: data["profileImageURL"] as? String
                    )
                }
                completion(comments)
            }
    }
    
    // MARK: - Gönderi Kaydetme Fonksiyonu
    func savePost(post: Post) {
        let postRef = db.collection("posts").document()
        let postData: [String: Any] = [
            "profileImageURL": post.profileImageURL ?? "",
            "username": post.username,
            "handle": post.handle,
            "timestamp": Timestamp(date: post.timestamp),
            "text": post.text,
            "likeCount": post.likeCount,
            "commentCount": post.commentCount,
            "postImageURL": post.postImageURL ?? "",
            "userID": post.userID, //
            "likedBy": [] // Başlangıçta boş beğeni listesi
        ]
        
        // Veriyi Firestore'a kaydediyoruz
        postRef.setData(postData) { error in
            if let error = error {
                print("Error saving post: \(error)")
            } else {
                print("Post saved successfully with ID: \(postRef.documentID)")
            }
        }
    }
    
    // MARK: - Tüm Gönderileri Alma Fonksiyonu
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        db.collection("posts").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching posts: \(error!)")
                completion([]) //
                return
            }
            
            let currentUserID = Auth.auth().currentUser?.uid ?? "" // aktif kullanıcı id
            
            // Belgeleri `Post` nesnelerine dönüştür
            let posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                let likedBy = data["likedBy"] as? [String] ?? [] //
                let isLiked = likedBy.contains(currentUserID) // akfif kullanıcı beğenmiş mi
                
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
            completion(posts)
        }
    }
    
    // MARK: - Beğeni Ekleme/Kaldırma Fonksiyonu
    func toggleLike(for postID: String, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let postRef = db.collection("posts").document(postID)
        
        postRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching post data: \(error?.localizedDescription ?? "No error description")")
                completion(false)
                return
            }
            
            var likedBy = data["likedBy"] as? [String] ?? []
            var likeCount = data["likeCount"] as? Int ?? 0
            
            if likedBy.contains(userID) {
                likedBy.removeAll { $0 == userID }
                likeCount -= 1
            } else {
                likedBy.append(userID)
                likeCount += 1
            }
            
            postRef.updateData([ // beğeni ve ve sayısını güncelle
                "likedBy": likedBy,
                "likeCount": likeCount
                               ]) { error in
                                   if let error = error {
                                       print("Beğeni güncelleme hatası: \(error.localizedDescription)")
                                       completion(false)
                                   } else {
                                       completion(true)
                                   }
                               }
        }
    }
    
    // MARK: - Kullanıcıya Ait Gönderileri Alma Fonksiyonu
    func fetchPostsForUser(userID: String, completion: @escaping ([Post]) -> Void) {
        //id filtreleme
        db.collection("posts")
            .whereField("userID", isEqualTo: userID)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching posts for user: \(error)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found for user \(userID)")
                    completion([])
                    return
                }
                
                let currentUserID = Auth.auth().currentUser?.uid ?? ""
                
                let posts = documents.compactMap { doc -> Post? in
                    let data = doc.data()
                    let likedBy = data["likedBy"] as? [String] ?? []
                    let isLiked = likedBy.contains(currentUserID)
                    
                    print("Post ID: \(doc.documentID), timestamp: \(String(describing: data["timestamp"])), isLiked: \(isLiked), likedBy: \(likedBy)")
                    
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
                
                print("Fetched posts for user \(userID): \(posts.map { $0.timestamp })")
                completion(posts)
            }
        
    }
}
