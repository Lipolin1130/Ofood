//
//  ChatRoomViewModel.swift
//  Ofood
//
//  Created by funghi on 2023/1/4.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ChatRoomViewModel: ObservableObject {
    @Published var groupName: String = ""
    @Published var creater: String = ""
    @Published var groupPeople: [String] = []
    @Published var restaurant: String = ""
    @Published var key:String = UUID().uuidString
    @Published var food: [String] = []
    
    let db = Firestore.firestore()
    
    func async(chatRoomId: String){
        self.key = chatRoomId
        print("key: \(self.key)")
        self.db.collection("chatRooms").document(self.key).getDocument { (document, error) in
            if let document = document, document.exists {
                self.groupName = document["groupName"] as? String ?? ""
                self.creater = document["creater"] as? String ?? ""
                self.groupPeople = document["groupPeople"] as? [String] ?? []
                self.restaurant = document["restaurant"] as? String ?? ""
                self.food = document["food"] as? [String] ?? []
            }
        }
    }
}
