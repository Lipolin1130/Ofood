//
//  CreateRoomView.swift
//  Ofood
//
//  Created by funghi on 2023/1/3.
//

import SwiftUI
import CoreLocation
import MapKit

struct CreateRoomView: View {
    @EnvironmentObject var localSearchService: LocalSearchService
    @EnvironmentObject var personModel: PersonViewModel
    @State var title: String = ""
    @State var resturant: String = ""
    @State var search: String = ""
    @State var showMap: Bool = false
    @State var showList: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("群組名稱：")
                TextField("群組名稱", text: $title)
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
                
            } label: {
                Text("送出")
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .navigationTitle("創建房間")
        .sheet(isPresented: $showList) {
            LandmarkListView(search: $search, showList: $showList)
                .presentationDetents([.medium])
        }
    }
}

struct CreateRoomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomView().environmentObject(LocalSearchService())
    }
}
