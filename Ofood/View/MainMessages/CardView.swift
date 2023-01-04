//
//  CardView.swift
//  Ofood
//
//  Created by funghi on 2023/1/4.
//

import SwiftUI

struct CardView: View {
    var chatRoomId: String
    @StateObject var chatRoomModel = ChatRoomViewModel()
    @EnvironmentObject var personModel: PersonViewModel
    
    var body: some View {
        NavigationLink  { 
            ChatRoomView()
                .environmentObject(chatRoomModel)
                .environmentObject(personModel)
        } label: {
            VStack {
                HStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 44)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(chatRoomModel.groupName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.black)
                        Text(chatRoomModel.creater)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                    }
                    Spacer()
                    Text(chatRoomModel.restaurant)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.brown)
                }
                Divider()
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)
        }
        .onAppear {
            chatRoomModel.async(chatRoomId: chatRoomId)
        }
    }
}
