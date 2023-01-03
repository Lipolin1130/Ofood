//
//  PersonPage.swift
//  ShareEat
//
//  Created by funghi on 2022/12/30.
//

import SwiftUI
import SDWebImageSwiftUI

struct PersonPage: View {
    @EnvironmentObject var personModel: PersonViewModel
    @State var deleteButton = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    WebImage(url: URL(string: personModel.imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 128, height: 128)
                        .cornerRadius(64)
                    
                    Button {
                        personModel.logOut()
                    } label: {
                        Text("登出")
                            .padding()
                            .font(.title2)
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                    }
                    .padding(.bottom, 20)

                }
                .padding()
            }
            .background(Color.black.opacity(0.05).ignoresSafeArea())
            .navigationBarTitle("Hello, \(personModel.name)")
        }
        .onAppear{
            personModel.async()
            URLCache.shared.memoryCapacity = 1024 * 1024 * 512
        }
    }
}


struct PersonPage_Previews: PreviewProvider {
    static var previews: some View {
        PersonPage()
    }
}
