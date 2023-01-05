//
//  ChatRoomView.swift
//  Ofood
//
//  Created by funghi on 2023/1/4.
//

import SwiftUI

struct ChatRoomView: View {
    @EnvironmentObject var chatRoomModel: ChatRoomViewModel
    @EnvironmentObject var personModel: PersonViewModel
    
    @State var showQrcode: Bool = false
    @State var showAddFood: Bool = false
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading){
                
                Spacer()
                
                Text("訂購清單")
                    .font(.title)
                    .padding(.bottom, 10)
                
                ForEach(chatRoomModel.foodItem, id: \.self){ food in
                    HStack {
                        
                        Spacer()
                        
                        FoodListView(food: food)
                            .environmentObject(chatRoomModel)
                            .environmentObject(personModel)
                    }
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    if personModel.email == chatRoomModel.creater {
                        Button {
                            
                        } label: {
                            Text("送出訂單")
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: 100)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .padding(.bottom, 30)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 30)
            
            if showQrcode {
                QrcodeView(showQrcode: $showQrcode, key: chatRoomModel.key)
            }
        }
        .navigationTitle(chatRoomModel.restaurant)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        showAddFood.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    Button {
                        showQrcode.toggle()
                    } label: {
                        Image(systemName: "qrcode")
                    }
                }
                
            }
        }
        .sheet(isPresented: $showAddFood) {
            AddFood(showAddFood: $showAddFood)
                .environmentObject(personModel)
                .environmentObject(chatRoomModel)
        }
        .onAppear{
            chatRoomModel.async(chatRoomId: chatRoomModel.key)
        }
    }
}
