//
//  ChatView.swift
//  Message UI
//
//  Created by Bryce Chang on 11/4/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import Foundation
import SwiftUI

//struct IDUser: {
//
//}


struct ChatBubble<Content>: View where Content: View {
    let position: Bool
    let color : Color
    let content: () -> Content
    init(position: Bool, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.color = color
        self.position = position
    }
    
    var body: some View {
        HStack(spacing: 0 ) {
            content()
                .padding(.all, 15)
                .foregroundColor(Color.white)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(color)
                        .rotationEffect(Angle(degrees: position == false ? -50 : -130))
                        .offset(x: position == false ? -5 : 5)
                    ,alignment: position == false ? .bottomLeading : .bottomTrailing)
        }
        .padding(position == false ? .leading : .trailing , 15)
        .padding(position == true ? .leading : .trailing , 60)
        .frame(width: UIScreen.main.bounds.width, alignment: position == false ? .leading : .trailing)
    }
}



@available(iOS 14.0, *)
struct ChatView: View {
    @EnvironmentObject private var identity: Identity
    @EnvironmentObject private var contacts: Contacts
    
    var contact: Contact2
    @State var messageSent: String = ""
    
    var body: some View {
        
		//   TODO: need check, notification related attempt
        GeometryReader { geo in
            VStack {
                VStack{
                    HStack(spacing: 12) {
                        Spacer()
                        Text(contact.nickname)
                        Spacer()
                    }
                    .foregroundColor(Color("Color1"))
                    .background(Color("Color"))
                }.padding(.top, -50)
                .background(Color("Color").edgesIgnoringSafeArea(.top))
                .animation(.default)

//                MARK:- ScrollView
                CustomScrollView(scrollToEnd: true) {
                    LazyVStack {
                      ForEach(contact.fetchMessages(), id:\.id)
                        {message in
                            ChatBubble(position: message.sentByMe, color: message.sentByMe == true ?.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255) : .init(red: 0.765, green: 0.783, blue: 0.858)) {
                                Text(message.messageBody)
                            }
                        }
                    }
                }
                .onAppear {
					Contact2.sawNewMessage(contactid: contact.id)
				}
				
                //MARK:- text editor
                HStack {
                    ZStack {
                        TextEditor(text: $messageSent)
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundColor(.gray)
                    }.frame(height: 50)
                    
                    Button("Send") {
                        if messageSent != "" {
                            contact.createMessage(messageBody: messageSent, sentByMe: true)
                        }
                    }
                    .foregroundColor(Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255))
                }.padding()
            }.navigationBarBackButtonHidden(false)
            .navigationViewStyle(StackNavigationViewStyle())
        }
	}
}
