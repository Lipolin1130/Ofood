//
//  FoodListView.swift
//  Ofood
//
//  Created by funghi on 2023/1/5.
//

import SwiftUI

struct FoodListView: View {
    @EnvironmentObject var chatRoomModel: ChatRoomViewModel
    @EnvironmentObject var personModel: PersonViewModel
    @State var food: Food
    
    var body: some View {
        HStack (spacing: 20){
            
            Text(food.foodName)
            
            Button {
                if food.count > 1 {
                    food.count -= 1
                }
            } label: {
                Image(systemName: "minus.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .disabled(personModel.email != food.creater)
            
            
            Text("\(food.count)")
                .font(.title2)
                .fontWeight(.semibold)
            
            Button {
                food.count += 1
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .disabled(personModel.email != food.creater)
        }
    }
}
