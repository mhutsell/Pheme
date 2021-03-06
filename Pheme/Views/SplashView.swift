//
//  SplashView.swift
//  StorageV1
//
//  Created by Chen Gong on 11/10/21.
//
import SwiftUI

struct Logo2 : View {
    var body: some View {
        return VStack{
            Image("Icon")
            Text("Pheme")
                .foregroundColor(Color.init(red: 0.765, green: 0.783, blue: 0.858))
                .font(.largeTitle)
        }
    }
}

struct SplashView: View {
    @State var username: String = ""
    var body: some View {
        
        NavigationView {
        ZStack {
            Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255).edgesIgnoringSafeArea(.all)
            VStack{
                Logo2()
                    .padding()
                TextField("Username", text: $username)
                    .foregroundColor(Color.init(red: 0.765, green: 0.783, blue: 0.858))
                    .padding()
                    .cornerRadius(15.0)
                    .border(Color.init(red: 0.765, green: 0.783, blue: 0.858))
                    .frame(width: 350)
                NavigationLink("Login", destination: ContentView(username: self.username)).simultaneousGesture(TapGesture().onEnded{Identity.sharedInstance.idtt.nickname = username})
                    .font(.headline)
                    .foregroundColor(Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255))
                    .padding()
                    .background(Color.init(red: 0.765, green: 0.783, blue: 0.858))
                    .cornerRadius(15.0)
            }
        }
        .navigationBarBackButtonHidden(true)
        }
    }
}

