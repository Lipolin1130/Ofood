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
    
    var body: some View {
        ZStack {
            VStack {
                
            }
            
            if showQrcode {
                QrcodeView(showQrcode: $showQrcode, key: chatRoomModel.key)
            }
        }
        .navigationTitle(chatRoomModel.restaurant)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showQrcode.toggle()
                } label: {
                    Image(systemName: "qrcode")
                }
            }
        }
    }
}
