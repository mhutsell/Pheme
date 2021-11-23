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
    
    @EnvironmentObject private var identity: Identity
    @EnvironmentObject private var contacts: Contacts
    var username : String
    @Binding var expand : Bool
    
 //   @FetchRequest(
 //           sortDescriptors: [NSSortDescriptor(keyPath: \Contact.timeLatest, ascending:false)],
 //           animation: .default)
 //       var data: FetchedResults<Contact>
    
    var body : some View{
        var data = Array(contacts.contacts.values)
        VStack(spacing: 0){

            chatTopView(username: self.username, expand: self.$expand)
                .zIndex(25)
            List(data, id:\.id){i in

//                if i.id == 0{

                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: ChatView(contactId: i.id)) {
                            cellMessagesView(contactId : i.id)
                                .onAppear{
                                    self.expand = true
                                }
                                .onDisappear{
                                    self.expand = false
                                }
                        }.environmentObject(contacts)

                    } else {
                        // Fallback on earlier versions
                    }
//               // ii+=1
                }
//                else{
//                    if #available(iOS 14.0, *) {
//                        NavigationLink(destination: ChatView(id: i.name)) {
//                            cellMessagesView(data : i)
//                        }
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                }

            }
            .padding(.top, 5)
            .background(Color.white)
            .clipShape(shape())
            .offset(y: -25)
        }
}


struct chatTopView : View {

    @EnvironmentObject private var identity: Identity
    @EnvironmentObject private var contacts: Contacts
    @State var username: String
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
//    var key = Identity2.myKey()
//    var id = Identity2.myID()
//    var name = Identity2.myName()
    
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

//                Image(uiImage: generateQRCode(from: "\(self.name)\n\(self.key)\n\(self.id)"))
//                    .interpolation(.none)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//                    .padding()

            }

        }
        .padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("Color1"))
        .animation(.default)

    }

//    func generateQRCode(from string: String) -> UIImage {
//        let data = Data(string.utf8)
//        filter.setValue(data, forKey: "inputMessage")
//
//        if let outputImage = filter.outputImage{
//            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
//                return UIImage(cgImage: cgimg)
//            }
//        }
//        return UIImage(systemName: "xmark.circle") ?? UIImage()
//    }
}

struct cellMessagesView : View {

    @EnvironmentObject private var identity: Identity
    @EnvironmentObject private var contacts: Contacts
    var contactId : UUID

    var body : some View{
        var contact = contacts.contacts[contactId]
        HStack(spacing: 12){

            Image(systemName:"person.crop.circle.fill")
            .resizable()
            .frame(width: 55, height: 55)
            .foregroundColor(Color("Color"))
            
            VStack(alignment: .leading, spacing: 12) {

                Text(contact!.nickname)

                Text(contacts.LatestMessageString(id: contactId)).font(.caption)
            }

            Spacer(minLength: 0)

            VStack{
                Text(time())

                Spacer()
            }
        }.padding(.vertical)
    }
    
    func time () -> String {
        let time2 = contacts[contactId]?.timeLatest
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        return formatter1.string(from: time2!)
    }
}


struct contactTopView : View {
    
    @EnvironmentObject private var identity: Identity
    @EnvironmentObject private var contacts: Contacts
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





/*
GLOBAL stuff
 - Msg (data)
 - Contact (contact_list)
*/

struct Msg : Identifiable {
    
    var id : Int
    var name : String
    var msg : String
    var date : String
    var img : String
}

//struct Contact : Identifiable {
//    var id : Int
//    var public_key : Int
//    var name : String
//    var username : String
//    var img : String
//}

//var contact_list:[Contact] = Contact.fetchContacts()




struct MessagesView_Previews: PreviewProvider {
    @State static var expand: Bool = true
    static var previews: some View {
        MessageView(username: "Pheme", expand: $expand)
    }
}

