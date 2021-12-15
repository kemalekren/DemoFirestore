//
//  ContentView.swift
//  DemoFirestore
//
//  Created by Kemal Ekren on 12.12.2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct Home: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        NavigationView {
            VStack {
                if status {
                    CityView()
                } else {
                    ZStack {
                        NavigationLink(isActive: self.$show) {
                            Register(show: self.$show)
                        } label: {
                            Text("")
                        }
                        .hidden()
                        Login(show: self.$show)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct Login: View {
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var password = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
        ZStack{
            ZStack(alignment: .topTrailing) {
                GeometryReader { _ in
                    VStack {
                        Image("logo")
                            .resizable()
                        //                .frame(width: 100, height: 100)
                        
                        Text("Log into Your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : color, lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15) {
                            VStack {
                                if self.visible {
                                    TextField("Password", text: self.$password)
                                } else {
                                    SecureField("Password", text: self.$password)
                                }
                            }
                            
                            Button {
                                self.visible.toggle()
                            } label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Color") : color, lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("Forget Password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color"))
                            }
                            
                        }
                        .padding(.top, 20)
                        
                        Button {
                            self.verify()
                            
                        } label: {
                            Text("Log In")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                        
                    }
                    .padding(.horizontal, 25)
                    
                }
                Button {
                    self.show.toggle()
                } label: {
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Color"))
                }
                .padding()
            }
            
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    func verify() {
        if self.email != "" && self.password != "" {
            Auth.auth().signIn(withEmail: self.email, password: self.password) { result, err in
                if let error = err {
                    self.error = error.localizedDescription
                    self.alert.toggle()
                    return
                }
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        } else {
            self.error = "Please fill the empty areas"
            self.alert.toggle()
        }
    }
}

struct Register: View {
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var password = ""
    @State var rePassword = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var errorMessage = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { _ in
                VStack {
                    Image("logo")
                        .resizable()
                    
                    Text("Log into Your account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        .padding(.top, 35)
                    
                    TextField("Email", text: self.$email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : color, lineWidth: 2))
                        .padding(.top, 25)
                    
                    HStack(spacing: 15) {
                        VStack {
                            if self.visible {
                                TextField("Password", text: self.$password)
                            } else {
                                SecureField("Password", text: self.$password)
                            }
                        }
                        
                        Button {
                            self.visible.toggle()
                        } label: {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.color)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Color") : color, lineWidth: 2))
                    .padding(.top, 25)
                    
                    HStack(spacing: 15) {
                        VStack {
                            if self.visible {
                                TextField("Re-Enter", text: self.$rePassword)
                            } else {
                                SecureField("Re-Enter", text: self.$rePassword)
                            }
                        }
                        
                        Button {
                            self.visible.toggle()
                        } label: {
                            Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.color)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.rePassword != "" ? Color("Color") : color, lineWidth: 2))
                    .padding(.top, 25)
                    
                    Button {
                        if !self.email.isEmpty, self.password == rePassword {
                            Auth.auth().createUser(withEmail: self.email, password: self.password) { result, err in
                                if let error = err {
                                    self.errorMessage = error.localizedDescription
                                    self.alert.toggle()
                                    return
                                }
                                
                                UserDefaults.standard.set(true, forKey: "status")
                                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                            }
                        } else if self.email.isEmpty {
                            self.errorMessage = "Email Can't be Empty"
                            self.alert.toggle()
                        } else {
                            self.errorMessage = "Passwords not matched"
                            self.alert.toggle()
                        }
                        
                    } label: {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color("Color"))
                    .cornerRadius(10)
                    .padding(.top, 25)
                    
                    
                }
                .padding(.horizontal, 25)
                
            }
            Button {
                self.show.toggle()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("Color"))
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct Homescreen : View {
    
    var body: some View{
        
        VStack{
            
            Text("Logged successfully")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }) {
                
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
        }
    }
}

struct CityView: View {
    @State var image = "profile_img"
    @State var image2 = "suit.heart.fill"
    @State var userName = "traveller4life"
    @State var likeCount = "1234"
    @State var placeName = "Best Church View"
    @State var category = "Photos & Landscapes"
    @State var header = true
    @State var footer = false
    
    
    var body: some View {
        ScrollView {
            
            ForEach((1...10), id: \.self) {_ in
                ZStack {
                    VStack {
                        CustomView(image: self.$image, userName: self.$userName, category: self.$category, header: self.$header)
                        Image("city")
                            .resizable()
                            .scaledToFill()
                        CustomView(image: self.$image2, userName: self.$likeCount, category: self.$placeName, header: self.$footer)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding()
                .shadow(color: .black, radius: 5)
            }
        }
    }
}

struct CustomView: View {
    @Binding var image: String
    @Binding var userName: String
    @Binding var category: String
    @Binding var header: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            if header {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .padding(.leading, 5)
                    .padding(.top, 5)
                
                Text(userName)
                    .fontWeight(.light)
                    .font(.title2)
                    .italic()
                    .padding(.top, 5)
                Spacer()
                Text(category)
                    .fontWeight(.light)
                    .italic()
                    .font(.subheadline)
                    .italic()
                    .padding(.trailing, 5)
                    .padding(.top, 5)
            } else {
                Image(systemName: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .padding(.leading, 5)
                    .padding(.bottom, 5)
                    .foregroundColor(Color("Color"))
                
                Text(userName)
                    .fontWeight(.light)
                    .font(.title2)
                    .italic()
                    .padding(.bottom, 5)
                Spacer()
                Text(category)
                    .fontWeight(.light)
                    .italic()
                    .font(.subheadline)
                    .italic()
                    .padding(.trailing, 5)
                    .padding(.bottom, 5)
            }
        }
    }
}

struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            //            .frame(width: UIScreen.main.bounds.width)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
