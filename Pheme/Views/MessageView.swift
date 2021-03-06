//
//  MessagesView.swift
//  StorageV1
//
//  Created by Chen Gong on 11/23/21.
//

import SwiftUI


struct shape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}




/*
Everything we need for the Messages page
 - struct Messages
 - struct chatTopView
 - struct messagesCentertview
 - struct cellMessagesView
*/

struct MessageView : View {
    

	@ObservedObject private var contacts = Contacts.sharedInstance
    var username : String
    @Binding var expand : Bool
    
    var body : some View{
        VStack(spacing: 0){

            chatTopView(username: self.username, expand: self.$expand)
                .zIndex(25)
            List(Array(contacts.contacts.values.sorted()), id:\.id){i in

                    if #available(iOS 14.0, *) {
                        
                        NavigationLink(destination: ChatView(contactId: i.id)) {
                            cellMessagesView(contactId : i.id)
                                .onAppear{
                                    self.expand = true
                                }
                                .onDisappear{
                                    self.expand = false
                                }
                        }

                    } else {
                        // Fallback on earlier versions
                    }
                }

            }
            .padding(.top, 5)
            .background(Color.white)
            .clipShape(shape())
            .offset(y: -25)
        }
}


struct chatTopView : View {

    @State var username: String
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
	
    @Binding var expand : Bool

    var body : some View{

        VStack(spacing: 5){

            if self.expand{

                HStack{

                    Text("Messages")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.7))

                    Spacer()

                    Button(action: {

                    }) {

                        Image("menu")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.black.opacity(0.4))
                    }
                }

            }

        }
        .padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("Color1"))
        .animation(.default)

    }

}

struct cellMessagesView : View {

    @ObservedObject private var contacts = Contacts.sharedInstance
    @State var showingAlert = false
    var contactId : UUID

    var body : some View{
		HStack(spacing: 12){
			if contacts.contacts[contactId] != nil {
				if(contacts.contacts[contactId]!.newMessage){
					GeometryReader { proxy in
						ZStack {

							Image(systemName: "person.crop.circle.fill")
								.resizable()
								.foregroundColor(Color("Color"))
								.frame(
									   width: proxy.size.width,
									   height: proxy.size.width,
									   alignment: .center
								)
							Image(systemName: "circle.fill")
								.resizable()
								.foregroundColor(.red)
								.frame(
									   width: proxy.size.width * 0.4,
									   height: proxy.size.width * 0.4
								)
								.padding(.bottom, 37.5)
								.padding(.leading, 37.5)
								.onLongPressGesture(minimumDuration: 1) {
									showingAlert = true
								}
								.alert(isPresented: $showingAlert) {
									Alert(title: Text("Are you sure to delete this contact?"),
										primaryButton: .destructive(Text("Delete")) {
											contacts.deleteContact(id: contactId)
										},
										secondaryButton: .cancel()
									)
								}
						}
					}.frame(width: 55, height: 55, alignment: .center)
				} else{
					Image(systemName:"person.crop.circle.fill")
					.resizable()
					.frame(width: 55, height: 55)
					.foregroundColor(Color("Color"))
					.onLongPressGesture(minimumDuration: 1) {
						showingAlert = true
					}
					.alert(isPresented: $showingAlert) {
						Alert(title: Text("Are you sure to delete all messages of this contact?"),
							primaryButton: .destructive(Text("Delete")) {
								contacts.deleteAllMessages(id: contactId)
							},
							secondaryButton: .cancel()
						)
					}
				}
				
				VStack(alignment: .leading, spacing: 12) {

					Text(contacts.contacts[contactId]!.nickname)

					Text(contacts.contacts[contactId]!.LatestMessageString())
					.font(.caption)
					.foregroundColor(contacts.contacts[contactId]!.newMessage == true ? .red : .black)
				}

				Spacer(minLength: 0)

				VStack{
					Text(time())
					Spacer()
				}
			}
        }.padding(.vertical)
    }
    
    func time () -> String {
        let time2 = contacts.contacts[contactId]!.timeLatest
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        return formatter1.string(from: time2)
    }
}


struct contactTopView : View {
    
    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 22){
            
            if self.expand{
                
                HStack{
                    
                    Text("Contacts")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        
                        Image("menu")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.black.opacity(0.4))
                    }
                }
                
            }
            
        }.padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("Color1"))
        .animation(.default)
        
    }
}



struct MessagesView_Previews: PreviewProvider {
    @State static var expand: Bool = true
    static var previews: some View {
        MessageView(username: "Pheme", expand: $expand)
    }
}

