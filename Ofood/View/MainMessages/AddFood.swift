//
//  AddFood.swift
//  Ofood
//
//  Created by funghi on 2023/1/4.
//

import SwiftUI
import FirebaseFirestore

struct AddFood: View {
    @EnvironmentObject var chatRoomModel: ChatRoomViewModel
    @EnvironmentObject var personModel: PersonViewModel
    @State var addFood: String = ""
    @State var count: Int = 1
    @Binding var showAddFood: Bool
    var body: some View {
        VStack (alignment: .center, spacing: 20){
            TextField("食物名稱", text: $addFood)
                .textFieldStyle(.roundedBorder)
                .padding()
            HStack (spacing: 30){
                Text("數量：")
                
                Button {
                    if count > 1 {
                        count -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                Text("\(count)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Button {
                    count += 1
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                Button {
                    if addFood != "" {
                        AddFood(foodName: addFood, creater: personModel.email, count: count, roomID: chatRoomModel.key)
                        chatRoomModel.async(chatRoomId: chatRoomModel.key)
                    }
                } label: {
                    Text("添加")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: 100)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
        .presentationDetents([.fraction(0.3)])
    }
    
    func AddFood(foodName: String, creater: String, count: Int, roomID: String) {
        let foodId = UUID().uuidString
        Firestore.firestore().collection("food").document(foodId).setData([
            "foodName": foodName,
            "creater": creater,
            "count": count,
            "roomID": roomID,
            "foodId": foodId
        ])
        
        Firestore.firestore().collection("chatRooms").document(roomID).updateData([
            "food": FieldValue.arrayUnion([foodId])
        ])
        showAddFood.toggle()
    }
}
