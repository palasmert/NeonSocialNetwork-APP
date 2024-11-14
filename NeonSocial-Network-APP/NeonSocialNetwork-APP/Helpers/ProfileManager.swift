//
//  ProfileManager.swift
//  NeonSocialNetwork-APP
//
//  Created by mert palas on 7.11.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProfileManager {
    
    static let shared = ProfileManager()
    
    private let defaults = UserDefaults.standard
    private let db = Firestore.firestore()
    private let userKey = "currentUser"
    
    // MARK: - Firestore ve UserDefaults’a Kullanıcı Kaydetme
    func saveUser(_ user: UserData) {
        do {
            let encodedData = try JSONEncoder().encode(user)
            defaults.set(encodedData, forKey: userKey)
            print("User saved to UserDefaults successfully.")
            
            // Firestore’a kullanıcı verisini bir sözlük yapısı olarak kaydediyoruz.
            let userData: [String: Any] = [
                "uid": user.uid,
                "email": user.email ?? "",
                "username": user.username ?? "",
                "nickName": user.nickName ?? "",
                "profileImageURL": user.profileImageURL ?? "",
                "bio": user.bio ?? "",
                "followersCount": user.followersCount ?? 0,
                "followingCount": user.followingCount ?? 0,
                "postCount": user.postCount ?? 0
            ]
            
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    print("Error saving user data to Firestore: \(error.localizedDescription)")
                } else {
                    print("User data saved to Firestore successfully.")
                }
            }
            
        } catch {
            print("Error encoding user data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UserDefaults’dan Kullanıcı Bilgisi Alma
    func getUser() -> UserData? {
        guard let data = defaults.data(forKey: userKey) else { return nil }
        
        do {
            let user = try JSONDecoder().decode(UserData.self, from: data)
            return user
        } catch {
            print("Error getting user: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - UserDefaults’dan Kullanıcı Silme
    func removeUser() {
        defaults.removeObject(forKey: userKey)
        print("User removed from UserDefaults.")
    }
    
    // MARK: - Yardımcı Yöntemler
    var isUserLoggedIn: Bool {
        return getUser() != nil
    }
    
    // MARK: - Firestore’dan Kullanıcı Bilgisi Alma
    func fetchUserData(completion: @escaping (UserData?) -> Void) {
            // Kullanıcının UID'sini alıyoruz
            guard let userID = Auth.auth().currentUser?.uid else {
                print("Kullanıcı kimliği bulunamadı.")
                completion(nil)
                return
            }
            
            // Firestore'dan kullanıcı verisini çekiyoruz
            let db = Firestore.firestore()
            db.collection("users").document(userID).getDocument { snapshot, error in
                if let error = error {
                    print("Kullanıcı verisi alınamadı: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                // Kullanıcı verisi mevcut mu kontrol ediyoruz
                guard let data = snapshot?.data() else {
                    print("Veri bulunamadı.")
                    completion(nil)
                    return
                }
                
                // UserData nesnesini oluşturuyoruz
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
                
                // completion ile veriyi döndürüyoruz
                completion(userData)
            }
        }
    
    // MARK: - Gönderi Sayısını Arttırma
    func incrementPostCount(for userID: String) {
        let userRef = db.collection("users").document(userID)
        
        userRef.updateData([
            "postCount": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error incrementing post count: \(error.localizedDescription)")
            } else {
                print("Post count incremented successfully.")
            }
        }
    }
}
