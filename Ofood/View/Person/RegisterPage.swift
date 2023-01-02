//
//  RegisterPage.swift
//  ShareEat
//
//  Created by funghi on 2022/12/30.
//

import SwiftUI

struct RegisterPage: View {
    @EnvironmentObject var loginModel: PersonViewModel
    var body: some View {
        VStack (alignment: .leading){
            HStack{
                Spacer()
                Text("註冊")
                    .font(.title)
                    .padding(.vertical, 20)
                Spacer()
            }
            
            Group {
                TextField("名稱", text: $loginModel.name)
                    .font(.title2)
                    .padding()
                    .autocapitalization(.none)
                    .background{
                        RoundedRectangle(cornerRadius: 9)
                            .fill(
                                loginModel.name == "" ? Color.black.opacity(0.05) : Color.blue.opacity(0.1)
                            )
                    }
                
            }
            .padding([.leading, .trailing], 5)
            
            
            
            Group {
                TextField("信箱", text: $loginModel.email)
                    .font(.title2)
                    .padding()
                    .autocapitalization(.none)
                    .background {
                        RoundedRectangle(cornerRadius: 9)
                            .fill(
                                loginModel.email == "" ? Color.black.opacity(0.05) : Color.blue.opacity(0.1)
                            )
                    }
                
            }
            .padding([.leading, .trailing], 5)
            
            
            SecureField("密碼", text: $loginModel.password)
                .font(.title2)
                .padding()
                .autocapitalization(.none)
                .background {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(
                            loginModel.password == "" ? Color.black.opacity(0.05) : Color.blue.opacity(0.1)
                        )
                }
                .padding(.bottom, 40)
            
            HStack {
                Spacer()
                Button {
                    if loginModel.name == "" {
                        loginModel.errorMsg = "你需要填寫名稱"
                        loginModel.showError.toggle()
                    } else {
                        Task {
                            do {
                                try await loginModel.register()
                                try await loginModel.loginUser()
                                loginModel.logStatus = true
                            } catch {
                                loginModel.errorMsg = error.localizedDescription
                                loginModel.showError.toggle()
                            }
                        }
                    }
                } label: {
                    Text("送出")
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
                Spacer()
            }
            
            
        }
        .padding()
        .alert(loginModel.errorMsg, isPresented: $loginModel.showError){}
        .onAppear{
            loginModel.email = ""
            loginModel.name = ""
            loginModel.password = ""
        }
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage()
    }
}
