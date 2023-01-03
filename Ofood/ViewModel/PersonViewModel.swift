//
//  PersonViewModel.swift
//  ShareEat
//
//  Created by funghi on 2022/12/30.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class PersonViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    @Published var name: String = ""
    @Published var errorMsg: String = ""
    @Published var imageUrl: String = ""
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    let db = Firestore.firestore()
    
    func loginUser()async throws {
        let _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func sendEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func logOut() {
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    func persistImageToStorage(image: UIImage, completion: @escaping (String) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: filename)
        guard let imageData = image.jpegData(compressionQuality: 0.5)else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    return
                }
                print(url!.absoluteString)
                self.imageUrl = url!.absoluteString
                completion(url!.absoluteString)
                print("imageUrl:   \(self.imageUrl)")
            }
        }
    }
    
    func register(uploadImage: UIImage)async throws {
        persistImageToStorage(image: uploadImage) { changeUrl in
            self.imageUrl = changeUrl
            self.db.collection("user").document(self.email).setData([
                "email": self.email,
                "name": self.name,
                "imageUrl": changeUrl
            ])
        }
        
        let _ = try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func async() {
        let _ = Auth.auth().addStateDidChangeListener{auth, user in
            let user = Auth.auth().currentUser
            if let user = user {
                print(user.email ?? "error email")
                self.email = user.email ?? "error email"
            }
            self.db.collection("user").document(self.email).getDocument{(document, error) in
                if let document = document {
                    print("Cached document data: \(document.data()?["name"] ?? "none")")
                    print("imageUrl:\(document.data()?["imageUrl"] ?? "none")")
                    self.name = document.data()?["name"] as! String
                    self.imageUrl = document.data()?["imageUrl"] as! String
                } else {
                    print("document is empty")
                }
            }
        }
    }
}
