//
//  homeView.swift
//  StorageV1
//
//  Created by Chen Gong on 11/23/21.
//

import Foundation
import SwiftUI

// This determines which part of homepage is displayed
struct Home : View {
    
//    @EnvironmentObject private var identity: Identity
//    @EnvironmentObject private var contacts: Contacts
    var username : String
    
    @State var index = 1
    @State var expand = true
    
    
    var body : some View{
        
        ZStack{
            
            VStack{
                
                Color.white
                Color("Color")
            }
            
            VStack{
                // checks Messages, Contacts, Settings
                ZStack{
                    
                    MessageView(username: self.username, expand: self.$expand)
                        .opacity(self.index == 0 ? 1 : 0)
//                        .environmentObject(identity)
//                        .environmentObject(contacts)
//
                    ContactsView(expand: self.$expand)
                        .opacity(self.index == 1 ? 1 : 0)
//                        .environmentObject(identity)
//                        .environmentObject(contacts)
                    
                    SettingsView(username: self.username)
                        .opacity(self.index == 2 ? 1 : 0)
//                        .environmentObject(identity)
//                        .environmentObject(contacts)
            
                }
                
                BottomView(index: self.$index)
                    .padding()
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BottomView : View {
    
//    @EnvironmentObject private var identity: Identity
    @Binding var index : Int
    
    var body : some View{
        
        HStack{
            
            Button(action: {
                
                self.index = 0
                
            }) {
                Image(systemName: "message.fill")
                .resizable()
                .frame(width: 25, height: 25)
                    .foregroundColor(self.index == 0 ? Color.white : Color.white.opacity(0.5))
                .padding(.horizontal)
            }
            
            Spacer(minLength: 10)
            
            Button(action: {
                
                self.index = 1
                
            }) {
                
                Image(systemName: "person.2.fill")
                .resizable()
                .frame(width: 28, height: 25)
                .foregroundColor(self.index == 1 ? Color.white : Color.white.opacity(0.5))
                .padding(.horizontal)
            }
            
            Spacer(minLength: 10)
            
            Button(action: {

                self.index = 2

            }) {

                Image(systemName: "gearshape.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(self.index == 2 ? Color.white : Color.white.opacity(0.5))
                .padding(.horizontal)
            }
            
        }.padding(.horizontal, 30)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
    }
}
