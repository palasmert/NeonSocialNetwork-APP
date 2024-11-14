//
//  PostViewController.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 6.11.2024.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let postView = PostView()
    private var selectedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPostView()
        loadUserProfileImage()
    }
    
    private func setupPostView() {
        view.addSubview(postView)
        postView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        postView.delegate = self
    }
    
    private func loadUserProfileImage() {
        if let profileImageURL = ProfileManager.shared.getUser()?.profileImageURL,
           let url = URL(string: profileImageURL) {
            postView.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    private func createPost(with text: String, imageURL: String?) {
        let userData = ProfileManager.shared.getUser()
        
        let post = Post(
            id: UUID().uuidString,
            profileImageURL: userData?.profileImageURL,
            username: userData?.username ?? "",
            handle: userData?.nickName ?? "",
            timestamp: Date(),
            nickName: userData?.nickName ?? "",
            text: text,
            likeCount: 0,
            commentCount: 0,
            postImageURL: imageURL,
            userID: userData?.uid ?? "",
            likedBy: [],
            isLiked: false
        )
        
        PostManager.shared.savePost(post: post)
        ProfileManager.shared.incrementPostCount(for: userData?.uid ?? "")
        self.dismiss(animated: true)
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Görseli JPEG formatına dönüştürme başarısız oldu.")
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("post_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Görsel yüklenirken hata oluştu: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("İndirme URL'si alınırken hata oluştu: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }
}

// MARK: - PostViewDelegate

extension PostViewController: PostViewDelegate {
    func didTapBackButton() {
        dismiss(animated: true)
    }
    
    func didTapAddImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    func didTapShareButton(with text: String) {
        if let selectedImage = selectedImage {
            uploadImage(selectedImage) { [weak self] url in
                guard let self = self else { return }
                self.createPost(with: text, imageURL: url?.absoluteString)
            }
        } else {
            createPost(with: text, imageURL: nil)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PostViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            postView.postImageView.image = selectedImage
            postView.postImageView.isHidden = false
        } else {
            print("Görsel atanmadı.")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
