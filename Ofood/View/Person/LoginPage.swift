//
//  LoginPage.swift
//  ShareEat
//
//  Created by funghi on 2022/12/30.
//

import SwiftUI

import SwiftUI

struct LoginPage: View {
    
    @EnvironmentObject var loginModel: PersonViewModel
    @State private var showSheet = false
    @State var showPass = false
    
    var body: some View {
        ZStack {
            Color.brown.opacity(0.3)
                .ignoresSafeArea(.all)
            VStack{
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 200)
                
                Text("Ofood")
                    .font(.title)
                    .fontWeight(.black)
                
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email", text: $loginModel.email)
                        .textInputAutocapitalization(.never)
                }
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(Color.white)
                }
                .padding(.top, 20)
                
                HStack {
                    Image(systemName: "lock")
                    
                    Group {
                        if showPass {
                            TextField("password", text: $loginModel.password)
                        } else {
                            SecureField("password", text: $loginModel.password)
                        }
                    }
                    .textInputAutocapitalization(.never)
                    
                    Button {
                        showPass.toggle()
                    } label: {
                        Image(systemName: self.showPass ? "eye.slash" :"eye")
                            .accentColor(.gray)
                    }
                    
                }
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(Color.white)
                }
                .padding(.top, 15)
                
                
                HStack{
                    Spacer()
                    Button {
                        alertTF(
                            title: "Help",
                            message: "?????????????????????\n ???????????????????????????????????????",
                            hintText: "example@gmail.com",
                            primaryTitle: "??????",
                            secondaryTitle: "??????") {email in
                                
                                loginModel.sendEmail(email: email)
                                
                            } secondaryAction: {
                                print("cancel")
                            }
                    } label: {
                        Text("???????????????")
                            .font(.callout)
                            .underline()
                            .foregroundColor(Color.gray)
                            .padding([.horizontal, .top], 15)
                    }
                }
                
                Button {
                    Task{
                        do{
                            try await loginModel.loginUser()
                            loginModel.logStatus = true
                        } catch {
                            loginModel.errorMsg = error.localizedDescription
                            loginModel.showError.toggle()
                        }
                    }
                } label: {
                    Text("??????")
                        .padding()
                        .font(.title2)
                        .frame(width: 300, height: 50)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                .padding(.vertical, 15)
                .disabled(loginModel.email == "" || loginModel.password == "")
                .opacity(loginModel.email == "" || loginModel.password == "" ? 0.5 : 1)
                
                Button {
                    self.showSheet = true
                } label: {
                    Text("??????")
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
                .padding(15)
                .sheet(isPresented: $showSheet) {
                    RegisterPage()
                        .environmentObject(loginModel)
                }
                
            }
            .padding(.horizontal, 25)
            .padding(.vertical)
        }
        .alert(loginModel.errorMsg, isPresented: $loginModel.showError){}
        .onAppear {
            loginModel.password = ""
            loginModel.email = ""
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}


extension View{
    func alertTF(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping(String)->(), secondaryAction: @escaping()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField{field in
            field.placeholder = hintText
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: {_ in
            secondaryAction()
        }))
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: {_ in
            if let text = alert.textFields?[0].text{
                primaryAction(text)
            }
            else{
                primaryAction("")
            }
        }))
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func rootController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
