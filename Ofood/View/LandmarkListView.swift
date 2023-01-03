//
//  LandmarkListView.swift
//  Ofood
//
//  Created by funghi on 2023/1/3.
//

import SwiftUI
import MapKit

struct LandmarkListView: View {
    @EnvironmentObject var localSearchService: LocalSearchService
    @Binding var search: String
    @Binding var showList: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            List(localSearchService.landmarks) { landmark in
                VStack {
                    Text(landmark.name)
                    Text(landmark.title)
                        .opacity(0.5)
                }
                .listRowBackground(localSearchService.landmark == landmark ? Color(UIColor.lightGray) : Color.white)
                .onTapGesture {
                    showList.toggle()
                    search = landmark.name
                    localSearchService.landmark = landmark
                    withAnimation {
                        localSearchService.region = MKCoordinateRegion.regionFromLandmark(landmark)
                    }
                }
            }
        }
    }
}
//
//struct LandmarkListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LandmarkListView(search: "")
//    }
//}
