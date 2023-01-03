//
//  HomeView.swift
//  ShareEat
//
//  Created by funghi on 2022/12/30.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var personModel: PersonViewModel
    var body: some View {
        TabView {
            MainMessagesView().tabItem {
                NavigationLink(destination: MainMessagesView()){
                    Image(systemName: "pencil")
                    Text("內容")
                }

            }
            PersonPage().tabItem {
                NavigationLink(destination: PersonPage().environmentObject(personModel)){
                    Image(systemName: "person.fill")
                    Text("個人資訊")
                }
            }
        }
        .onAppear {
            personModel.async()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
