//
//  SocketService.swift
//  Ofood
//
//  Created by funghi on 2023/1/4.
//

import Foundation
import SocketIO

final class SocketService: ObservableObject {
    private var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    @Published var messages = [String]()
    
    init() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {(data, ack) in
            print("Connected")
        }
        socket.connect()
    }
}
