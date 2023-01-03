//
//  RegisterPage.swift
//  ShareEat
//
//  Created by funghi on 2022/12/30.
//

import SwiftUI

struct RegisterPage: View {
    @State var shouldShowImagePicker = false
    @EnvironmentObject var loginModel: PersonViewModel
    @State var image: UIImage?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10){
            HStack{
                Spacer()
                Text("註冊")
                    .font(.title)
                    .padding(.vertical, 20)
                Spacer()
            }
            
            Group {
                HStack {
                    Spacer()
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 64))
                                    .padding()
                                    .foregroundColor(Color(.label).opacity(0.4))
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color.black, lineWidth: 3).opacity(0.4)
                        )
                    }
                    Spacer()
                }
                .padding()
                
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
            .padding([.leading, .trailing, .vertical], 10)
            
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
            .padding([.leading, .trailing, .vertical], 10)
            
            
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
                .padding(.vertical, 10)
                .padding(.bottom, 10)
            
            HStack {
                Spacer()
                Button {
                    if image != nil {
                        if loginModel.name == "" {
                            loginModel.errorMsg = "你需要填寫名稱"
                            loginModel.showError.toggle()
                        } else {
                            Task {
                                do {
                                    try await loginModel.register(uploadImage: image!)
                                    try await loginModel.loginUser()
                                    loginModel.logStatus = true
                                } catch {
                                    loginModel.errorMsg = error.localizedDescription
                                    loginModel.showError.toggle()
                                }
                            }
                        }
                    } else {
                        loginModel.errorMsg = "你需要上傳照片"
                        loginModel.showError.toggle()
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
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
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
