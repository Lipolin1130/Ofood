//
//  ContentView.swift
//  ShareEat
//
//  Created by funghi on 2022/12/30.
//

import SwiftUI

struct ContentView: View {
    @StateObject var personModel = PersonViewModel()
    var body: some View {
        if personModel.logStatus {
            HomeView()
                .environmentObject(personModel)
        } else {
            LoginPage()
                .environmentObject(personModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
