//
//  MainMessagesView.swift
//  Ofood
//
//  Created by funghi on 2023/1/3.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainMessagesView: View {
    @EnvironmentObject var personModel: PersonViewModel
    @State var showCreateRoom = false
    @State var showJoinRoom = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 16) {
                    
                    WebImage(url: URL(string: personModel.imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1)
                        )
                        .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(personModel.name)
                            .font(.system(size: 24, weight: .bold))
                        HStack {
                            
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 14, height: 14)
                            Text("online")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.lightGray))
                        }
                        
                    }
                    Spacer()
                    
                    NavigationLink(destination: CreateRoomView(showCreateRoom: $showCreateRoom).environmentObject(personModel), isActive: $showCreateRoom) {
                        Text("Create")
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: 70)
                            .background(Color("Purple"), in: Capsule())
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink(destination: JoinRoomView(showJoinRoom: $showJoinRoom).environmentObject(personModel), isActive: $showJoinRoom) {
                        Text("Join")
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: 70)
                            .background(Color("Orange"), in: Capsule())
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                ScrollView {
                    ForEach(personModel.chatRoom, id: \.self) { room in
                        CardView(chatRoomId: room)
                            .environmentObject(personModel)
                    }
                    
                    .padding(.bottom, 50)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            personModel.async()
            URLCache.shared.memoryCapacity = 1024 * 1024 * 512
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
