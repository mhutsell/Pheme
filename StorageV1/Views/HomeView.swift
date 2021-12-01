//
//  HomeView.swift
//  StorageV1
//
//  Created by Chen Gong on 11/23/21.
//

import Foundation
import SwiftUI
import UserNotifications

// This determines which part of homepage is displayed
struct Home : View {
    
    var username : String
    
    @State var index = 1
    @State var expand = true
    
    
    var body : some View{
    
		
        
        ZStack{
			
//			UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//				if success {
//					print("All set!")
//				} else if let error = error {
//					print(error.localizedDescription)
//				}
//			}
        
            
            VStack{
                
                Color.white
                Color("Color")
            }
            
            VStack{
                // checks Messages, Contacts, Settings
                ZStack{
                    
                    MessageView(username: self.username, expand: self.$expand)
                        .opacity(self.index == 0 ? 1 : 0)
//
                    ContactsView(expand: self.$expand)
                        .opacity(self.index == 1 ? 1 : 0)
                    
                    SettingsView(username: self.username)
                        .opacity(self.index == 2 ? 1 : 0)
            
                }
                
                BottomView(index: self.$index)
                    .padding()
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BottomView : View {
    
    @EnvironmentObject private var identity: Identity
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
