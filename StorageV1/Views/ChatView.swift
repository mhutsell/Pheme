//
//  ChatView.swift
//  Message UI
//
//  Created by Bryce Chang on 11/4/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import Foundation
import SwiftUI



struct ChatBubbleWithNN<Content>: View where Content: View {
    let position: Bool
    let color : Color
    let content: () -> Content
    let nickname: String
    init(position: Bool, nickname: String, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.nickname = nickname
        self.color = color
        self.position = position
    }
    
    var body: some View {
		VStack(spacing:0){
			Text(nickname)
				.font(.system(size: 10))
				.foregroundColor(Color("Color"))
			.padding(position == false ? .leading : .trailing , 20)
			.padding(position == true ? .leading : .trailing , 60)
			.frame(width: UIScreen.main.bounds.width, alignment: position == false ? .leading : .trailing)
			
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
}

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
    @ObservedObject private var contacts = Contacts.sharedInstance
    
    @State var contactId: UUID
    @State var messageSent: String = ""
    

    
    var body: some View {

        GeometryReader { geo in
            VStack {
                VStack{
                    HStack(spacing: 12) {
                        Spacer()
                        Text(contacts.contacts[contactId]!.nickname)
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
						if (contactId == Identity2.globalId) {
							ForEach(contacts.contacts[contactId]!.messages.values.sorted(), id:\.id)
							{message in
								ChatBubbleWithNN(position: message.sentByMe, nickname: message.senderNickname, color: message.sentByMe == true ?.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255) : .init(red: 0.765, green: 0.783, blue: 0.858)) {
									Text(message.messageBody)
								}
							}
						} else {
							ForEach(contacts.contacts[contactId]!.messages.values.sorted(), id:\.id)
							{message in
								ChatBubble(position: message.sentByMe, color: message.sentByMe == true ?.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255) : .init(red: 0.765, green: 0.783, blue: 0.858)) {
									Text(message.messageBody)
								}
							}
						}
                    }
                }
                .onAppear {
                    contacts.sawNewMessage(contactId: contactId)
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
                            contacts.createMessage(messageBody: messageSent, sentByMe: true, contactId: contactId)
                        }
                    }
                    .foregroundColor(Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255))
                }.padding()
            }.navigationBarBackButtonHidden(false)
            .navigationViewStyle(StackNavigationViewStyle())
        }
	}
}
