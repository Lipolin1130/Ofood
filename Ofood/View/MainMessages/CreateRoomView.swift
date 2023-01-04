//
//  CreateRoomView.swift
//  Ofood
//
//  Created by funghi on 2023/1/3.
//

import SwiftUI
import CoreLocation
import MapKit
import Firebase

struct CreateRoomView: View {
    @EnvironmentObject var localSearchService: LocalSearchService
    @EnvironmentObject var personModel: PersonViewModel
    @Binding var showCreateRoom: Bool
    
    @State var title: String = ""
    @State var resturant: String = ""
    @State var search: String = ""
    @State var showMap: Bool = false
    @State var showList: Bool = false
    @State var errorMsg: String = ""
    @State var showError: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("群組名稱：")
                TextField("Group1", text: $title)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            .padding(.top, 30)
            
            HStack {
                Text("餐廳：")
                TextField("Search", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        localSearchService.search(query: search)
                        showList.toggle()
                    }
            }
            .padding()
            
            Map(coordinateRegion: $localSearchService.region,showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
                MapAnnotation(coordinate: landmark.coordinate) {
                    Image(systemName: "fork.knife.circle")
                        .foregroundColor(localSearchService.landmark == landmark ? .purple: .blue)
                        .scaleEffect(localSearchService.landmark == landmark ? 2 : 1)
                }
            }
            .frame(width: 300, height: 300)
            
            Button {
                if title == "" {
                    errorMsg = "請填寫小組名稱"
                    showError.toggle()
                } else {
                    if search == "" {
                        errorMsg = "請填寫餐廳"
                        showError.toggle()
                    } else {
                        createRoom(groupName: title, creater: personModel.email, restaurant: search)
                        personModel.async()
                    }
                }
                
            } label: {
                Text("送出")
                    .padding()
                    .font(.title2)
                    .frame(width: 100, height: 30)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
            }
            
        }
        .padding(.horizontal, 10)
        .navigationTitle("創建房間")
        .sheet(isPresented: $showList) {
            LandmarkListView(search: $search, showList: $showList)
                .presentationDetents([.medium])
        }
        .alert(errorMsg, isPresented: $showError){}
    }
    
    func createRoom(groupName: String, creater: String, restaurant: String) {
        let key = UUID().uuidString
        Firestore.firestore().collection("chatRooms").document(key).setData([
            "groupName": groupName,
            "creater": creater,
            "groupPeople": [creater],
            "restaurant": restaurant,
            "key": key,
            "food": []
        ])
        
        Firestore.firestore().collection("user").document(creater).updateData([
            "chatRoom": FieldValue.arrayUnion([key])
        ])
        
        showCreateRoom.toggle()
    }
}

struct CreateRoomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomView(showCreateRoom: .constant(false)).environmentObject(LocalSearchService())
    }
}
