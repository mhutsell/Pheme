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

struct CustomScrollView<Content>: View where Content: View {
    var axes: Axis.Set = .vertical
    var reversed: Bool = false
    var scrollToEnd: Bool = false
    var content: () -> Content

    @State private var contentHeight: CGFloat = .zero
    @State private var contentOffset: CGFloat = .zero
    @State private var scrollOffset: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            if self.axes == .vertical {
                self.vertical(geometry: geometry)
            } else {
                // implement same for horizontal orientation
            }
        }
        .clipped()
    }

    private func vertical(geometry: GeometryProxy) -> some View {
        VStack {
            content()
        }
        .modifier(ViewHeightKey())
        .onPreferenceChange(ViewHeightKey.self) {
            self.updateHeight(with: $0, outerHeight: geometry.size.height)
        }
        .frame(height: geometry.size.height, alignment: (reversed ? .bottom : .top))
        .offset(y: contentOffset + scrollOffset)
        .animation(.easeInOut)
        .background(Color.white)
        .gesture(DragGesture()
            .onChanged { self.onDragChanged($0) }
            .onEnded { self.onDragEnded($0, outerHeight: geometry.size.height) }
        )
    }

    private func onDragChanged(_ value: DragGesture.Value) {
        self.scrollOffset = value.location.y - value.startLocation.y
    }

    private func onDragEnded(_ value: DragGesture.Value, outerHeight: CGFloat) {
        let scrollOffset = value.predictedEndLocation.y - value.startLocation.y

        self.updateOffset(with: scrollOffset, outerHeight: outerHeight)
        self.scrollOffset = 0
    }

    private func updateHeight(with height: CGFloat, outerHeight: CGFloat) {
        let delta = self.contentHeight - height
        self.contentHeight = height
        if scrollToEnd {
            self.contentOffset = self.reversed ? height - outerHeight - delta : outerHeight - height
        }
        if abs(self.contentOffset) > .zero {
            self.updateOffset(with: delta, outerHeight: outerHeight)
        }
    }

    private func updateOffset(with delta: CGFloat, outerHeight: CGFloat) {
        let topLimit = self.contentHeight - outerHeight

        if topLimit < .zero {
             self.contentOffset = .zero
        } else {
            var proposedOffset = self.contentOffset + delta
            if (self.reversed ? proposedOffset : -proposedOffset) < .zero {
                proposedOffset = 0
            } else if (self.reversed ? proposedOffset : -proposedOffset) > topLimit {
                proposedOffset = (self.reversed ? topLimit : -topLimit)
            }
            self.contentOffset = proposedOffset
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

extension ViewHeightKey: ViewModifier {
    func body(content: Content) -> some View {
        return content.background(GeometryReader { proxy in
            Color.clear.preference(key: Self.self, value: proxy.size.height)
        })
    }
}

@available(iOS 14.0, *)
struct ChatView: View {
    @State var contact: Contact2
//
//    @FetchRequest(
//                sortDescriptors: [NSSortDescriptor(keyPath: \Message.timeCreated, ascending:false)],
//                predicate: NSPredicate(format: "contact LIKE %@", self.contact),
//                animation: .default)
//        var message_list: FetchedResults<Message>
    
//    @State var message_list:[Message] = contact.fetchMessages()
    @State var messageSent: String = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack {
//                chatTopBar(id: self.id)
                VStack{
                    HStack(spacing: 12) {
                        Spacer()
                        Text(contact.nickname!)
                        Spacer()
                    }
                    .foregroundColor(Color("Color1"))
                    .background(Color("Color"))
                }.padding(.top, -50)
//                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
//                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .background(Color("Color").edgesIgnoringSafeArea(.top))
                .animation(.default)
//                .cornerRadius(5)
                
                
                
            
                //MARK:- ScrollView
                CustomScrollView(scrollToEnd: true) {
                    LazyVStack {
                        ForEach(0..<self.contact.fetchMessages().count, id:\.self) { index in
                            ChatBubble(position: self.contact.fetchMessages()[index].sentByMe, color: self.contact.fetchMessages()[index].sentByMe == true ?.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255) : .init(red: 0.765, green: 0.783, blue: 0.858)) {
                                Text(self.contact.fetchMessages()[index].messageBody!)
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
                            contact.createChatMessage(body: messageSent)
                        }
                    }
                    .foregroundColor(Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255))
                }.padding()
            }.navigationBarBackButtonHidden(false)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

//@available(iOS 14.0, *)
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(id: "abc")
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


