//
//  JoinRoomView.swift
//  Ofood
//
//  Created by funghi on 2023/1/4.
//

import SwiftUI
import CodeScanner

struct JoinRoomView: View {
    @EnvironmentObject var personModel: PersonViewModel
    @State private var isPresentingScanner = false
    @State private var scannedCode: String = ""
    @Binding var showJoinRoom: Bool
    
    var body: some View {
        VStack (spacing: 50){
            
            Button {
                isPresentingScanner = true
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .foregroundColor(.brown.opacity(0.3))
                    .frame(width: 200, height: 200)
            }
            
            TextField("Room Key: ", text: $scannedCode)
                .textFieldStyle(.roundedBorder)
            
            Button {
                if scannedCode != "" {
                    personModel.joinRoom(key: scannedCode)
                    personModel.async()
                    showJoinRoom = false
                }
            } label: {
                Text("Join")
                    .padding()
                    .font(.title)
                    .frame(width: 150, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
            }

        }
        .padding()
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.qr]) { response in
                if case let .success(result) = response {
                    scannedCode = result.string
                    isPresentingScanner = false
                }
            }
        }
    }
}

struct JoinRoomView_Previews: PreviewProvider {
    static var previews: some View {
        JoinRoomView(showJoinRoom: .constant(false))
    }
}
