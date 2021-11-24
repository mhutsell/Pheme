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
    @State var contactId: UUID
    @State var messageSent: String = ""
    
    var body: some View {
        let message_list = contacts.fetchMessages(id: contactId)
        
		//   TODO: need check, notification related attempt
//        contacts[contactId]!.newMessage = false
        GeometryReader { geo in
            VStack {
//                chatTopBar(id: self.id)
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
                        ForEach(message_list, id:\.id)
                        {message in
                            ChatBubble(position: message.sentByMe, color: message.sentByMe == true ?.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255) : .init(red: 0.765, green: 0.783, blue: 0.858)) {
                                Text(message.messageBody)
                            }
                        }
                    }
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
                            contacts.createMessage(body: messageSent, contactId: contactId)
                            
                        }
                    }
                    .foregroundColor(Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255))
                }.padding()
            }.navigationBarBackButtonHidden(false)
            .navigationViewStyle(StackNavigationViewStyle())
        }
	}
//	.onAppear(perform:
//		let contacts = Contacts()
//		contacts.sawNewMessage(contactId: contactId)
//	)
}
                    


//@available(iOS 14.0, *)
//struct ChatView_Previews: PreviewProvider {
//    @StateObject static var contacts = Contacts()
//
//    static var previews: some View {
//        ChatView(id: UUID())
//    }
//}

//struct chatTopBar : View {
//    var id: Int
//    
//    var body : some View{
//        VStack{
//            HStack(spacing: 12) {
//                Spacer()
//                Text(.name)
//                Spacer()
//            }
//            .foregroundColor(Color("Color1"))
//            .background(Color("Color"))
//        }
//        .padding()
//        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
//        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
//        .background(Color("Color"))
//        .clipShape(shape())
//        .animation(.default)
//        .edgesIgnoringSafeArea(.top)
//    }
//}
    /*
GLOBAL stuff
 - Msg (data)
 - Contact (contact_list)
*/



