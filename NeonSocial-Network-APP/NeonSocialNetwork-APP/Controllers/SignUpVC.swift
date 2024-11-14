//
//  SignUpViewController.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 3.11.2024.
//

import UIKit
import FirebaseAuth
import SwiftUICore
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let signUpView = SignUpView()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = signUpView
        setupButtonTargets()
        
        // Resim seçmek için image view'e tap gesture ekleme
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        signUpView.profileImageView.isUserInteractionEnabled = true
        signUpView.profileImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupButtonTargets() {
        signUpView.signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }
    
    // Resim seçme işlemini başlatma
    @objc private func handleProfileImageTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // Resim seçildikten sonra yapılacak işlemler
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            signUpView.profileImageView.image = image // Seçilen resmi gösterme
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    @objc private func handleSignUp() {
        guard let email = signUpView.emailTextField.text, !email.isEmpty,
              let password = signUpView.passwordTextField.text, !password.isEmpty,
              let aboutMe = signUpView.aboutMeTextField.text else {
            print("Email, Password, and About Me fields cannot be empty.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Sign up error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
        
            // Seçilen profil resmini Firebase Storage'a yükleyelim
            self.uploadProfileImage { photoURL in
                let displayName = self.signUpView.usernameTextField.text
                let nickName = self.signUpView.nicknameTextField.text ?? ""
                
                // Kullanıcı profili güncelleme
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = displayName
                changeRequest?.photoURL = photoURL
                changeRequest?.commitChanges { error in
                    if let error = error {
                        print("Error updating profile: \(error.localizedDescription)")
                    } else {
                        print("Profile updated successfully!")
                        
                        // Firestore'a kullanıcı verisini kaydetme
                        let userData = UserData(
                            uid: authResult?.user.uid ?? "",
                            email: authResult?.user.email ?? "",
                            username: displayName,
                            nickName: nickName,
                            profileImageURL: photoURL?.absoluteString ?? "",
                            bio: aboutMe,
                            followersCount: 0,
                            followingCount: 0,
                            postCount: 0
                        )
                        ProfileManager.shared.saveUser(userData)
                        
                        let successAlert = UIAlertController(title: "Success", message: "Registration successful!", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                            let loginVC = LoginViewController()
                            self?.navigationController?.pushViewController(loginVC, animated: true)
                        }))
                        self.present(successAlert, animated: true)
                    }
                }
            }
        }
    }
    
    // Profil resmini Firebase Storage'a yükleme
    private func uploadProfileImage(completion: @escaping (URL?) -> Void) {
        guard let selectedImage = selectedImage else {
            completion(nil)
            return
        }
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        // TODO: Storage işlemlerinin ayrı bir managerda olması daha iyi olur
        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                        completion(nil)
                    } else {
                        completion(url)
                    }
                }
            }
        }
    }
}
