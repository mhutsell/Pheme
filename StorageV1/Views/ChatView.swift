//
//  ChatView.swift
//  Message UI
//
//  Created by Bryce Chang on 11/4/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import Foundation
import SwiftUI



struct ChatBubble<Content>: View where Content: View {
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

struct ImageBubble: View  {
    let position: Bool
    let color : Color
    let image: UIImage
    let nickname: String
    init(position: Bool, nickname: String, color: Color, image: UIImage) {
        self.image = image
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
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
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


@available(iOS 14.0, *)
struct ChatView: View {
    @ObservedObject private var contacts = Contacts.sharedInstance
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var contactId: UUID
    @State var messageSent: String = ""
    
	func loadImage() {
		guard let inputImage: UIImage = inputImage else { return }
		contacts.createImageMessage(messageBody: inputImage, sentByMe: true, contactId: contactId)
	}
    
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
						ForEach(contacts.contacts[contactId]!.messages.values.sorted(), id:\.id)
						{message in
							message.messageType == 0 ? ImageBubble(position: message.sentByMe, nickname: message.senderNickname, color: message.sentByMe == true ?.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255) : .init(red: 0.765, green: 0.783, blue: 0.858), image: message.displayImageMessage()) : ChatBubble(position: message.sentByMe, nickname: message.senderNickname, color: message.sentByMe == true ?.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255) : .init(red: 0.765, green: 0.783, blue: 0.858)) {
								Text(message.messageBody)
							}
						}
                    }
                }
                .onAppear {
                    contacts.sawNewMessage(contactId: contactId)
				}
				
                //MARK:- text editor
                HStack {
					Button(action: {
                        self.showingImagePicker = true
                    }) {
                            Image(systemName: "photo")
                                .font(.system(size: 20))
								.background(Color.blue)
								.foregroundColor(.white)
								.padding(.horizontal)
								.sheet(isPresented: $showingImagePicker) {
									ImagePicker(image: $inputImage)
								}
								.onChange(of: inputImage) { _ in loadImage() }
                    }
//                    ZStack {
//                        Image(uiImage: self.inputImage)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(minWidth: 0, maxWidth: .infinity)
//                                        .edgesIgnoringSafeArea(.all)
//                        TextEditor(text: $messageSent)
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke()
//                            .foregroundColor(.gray)
//                    }.frame(height: 50)
                    ZStack {
                        TextEditor(text: $messageSent)
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundColor(.gray)
                    }.frame(height: 50)
                    
                    Button("Send") {
                        if messageSent != "" {
                            contacts.createMessage(messageBody: messageSent, sentByMe: true, contactId: contactId)
                            messageSent = ""
                        }
                    }
                    .foregroundColor(Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255))
                }.padding()
            }.navigationBarBackButtonHidden(false)
            .navigationViewStyle(StackNavigationViewStyle())
        }
	}
}

