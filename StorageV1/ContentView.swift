//  Pheme
//  Message, Contact, Setttings Page

import SwiftUI
import CoreImage.CIFilterBuiltins
import CoreData


// Create the base view
//@available(iOS 14.0, *)
struct ContentView: View {
    
    var username : String
    
    var body: some View {

        
        if #available(iOS 14.0, *) {
            Home(username: self.username)
                .navigationBarBackButtonHidden(true)
        } else {
            // Fallback on earlier versions
        }
    }
}

@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(username: "KunalSuri")
    }
}


// This determines which part of homepage is displayed
struct Home : View {
    var username : String
    
    @State var index = 1
    @State var expand = false
    
    
    var body : some View{
        
        ZStack{
            
            VStack{
                
                Color.white
                Color("Color")
            }
            
            VStack{
                // checks Messages, Contacts, Settings
                ZStack{
                    
                    Messages(expand: self.$expand).opacity(self.index == 0 ? 1 : 0)
                    
                    Contacts(expand: self.$expand).opacity(self.index == 1 ? 1 : 0)
                    
                    Settings(username: self.username).opacity(self.index == 2 ? 1 : 0)
                }
                
                BottomView(index: self.$index)
                    .padding()
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BottomView : View {
    
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

struct Messages : View {

    @Binding var expand : Bool

    var body : some View{
        VStack(spacing: 0){

            chatTopView(expand: self.$expand)
                .zIndex(25)

            List(data){i in

                if i.id == 0{

                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: ChatView(id: i.name)) {
                            cellMessagesView(data : i)
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
                else{
                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: ChatView(id: i.name)) {
                            cellMessagesView(data : i)
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
}

struct chatTopView : View {

    @State var username: String = "abc"
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    @State var search = ""
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

                Image(uiImage: generateQRCode(from: "\(username)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()

            }

            HStack(spacing: 12){

                Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(Color.black.opacity(0.3))

                TextField("Search Messages...", text: self.$search)

            }.padding()
            .background(Color.white)
            .cornerRadius(8)
            .padding(.bottom, 5)

        }.padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("Color1"))
        .clipShape(shape())
        .animation(.default)

    }

    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage{
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}


struct cellMessagesView : View {

    var data : Msg

    var body : some View{

        HStack(spacing: 12){

            Image(data.img)
            .resizable()
            .frame(width: 55, height: 55)

            VStack(alignment: .leading, spacing: 12) {

                Text(data.name)

                Text(data.msg).font(.caption)
            }

            Spacer(minLength: 0)

            VStack{

                Text(data.date)

                Spacer()
            }
        }.padding(.vertical)
    }
}

/*
Everything needed for the Contact page
 - struct Contacts
 - struct contactTopView
*/

struct Contacts : View {
    
    @Binding var expand : Bool
    
//    @FetchRequest(
//            sortDescriptors: [NSSortDescriptor(keyPath: \Contact.timeLatest, ascending:false)],
//            animation: .default)
//        var contact_list: FetchedResults<Contact>
    
    var body : some View{
        
        VStack(spacing: 0) {
            
            contactTopView(expand: self.$expand)
                .zIndex(25)
            
            Button(action: {
                                        Identity.createIdentity(nickname: "test")
                                        _ = Contact.createContact(nn: "contactTest", key: Identity.fetchIdentity().publicKey!, id: Identity.fetchIdentity().id!)
                                    }){
                                        Image(systemName: "plus.circle.fill")
                                             .foregroundColor(.blue)
                                             .imageScale(.large)
                                    }
            
            List(contact_list, id:\.nickname){i in
//                        if i.id == 0{
                            
                            if #available(iOS 14.0, *) {
                                NavigationLink(destination: ChatView(id: i.nickname!)) {
                                    cellContactView(contact_list : i)
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
//                        }
//                        else{
//                            if #available(iOS 14.0, *) {
//                                NavigationLink(destination: ChatView(id: i.id)) {
//                                    cellContactView(contact_list : i)
//                                }
//                            } else {
//                                // Fallback on earlier versions
//                            }
                        }
                        
            }       .padding(.top, 5)
                    .background(Color.white)
                    .clipShape(shape())
                    .offset(y : -25)
            }
        
        
    }
    


struct contactTopView : View {
    
    @State var search = ""
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
            
            HStack(spacing: 12){
                
                Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(Color.black.opacity(0.3))
                
                TextField("Search Contacts...", text: self.$search)
                
            }.padding()
            .background(Color.white)
            .cornerRadius(8)
            .padding(.bottom, 5)
            
        }.padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("Color1"))
        .clipShape(shape())
        .animation(.default)
        
    }
}


struct cellContactView : View {
    
    var contact_list : Contact
    @State var next: Bool = false
    
    var body : some View{
        HStack(spacing: 12){
            
//            Image(contact_list.img)
//            .resizable()
//            .frame(width: 55, height: 55)
//
            VStack(alignment: .leading, spacing: 12) {
            
                Text(contact_list.nickname!)
                
//                Text("@" + contact_list.username).font(.caption)
            }
            
            Spacer(minLength: 0)
            
            VStack{
                
                
                Spacer()
            }

        }.padding(.vertical)
    }
}

struct Settings : View {
    
    var username : String

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body : some View{
        
        GeometryReader{_ in
            
            VStack{
                
                Image(uiImage: generateQRCode(from: "\(username)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Text(self.username)
                    .font(.title)
                
            }
            .padding(.top)
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color.white)
        .clipShape(shape())
        .padding(.bottom)
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage{
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
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

var data = [
    
    Msg(id: 0, name: "John Doe", msg: "Hey!", date: "10/30/21",img: "pic1"),
    Msg(id: 1, name: "Sarah L", msg: "How are you doing?", date: "10/30/21",img: "pic2"),
    Msg(id: 2, name: "Catherine C", msg: "yeah it was super fun", date: "10/29/21",img: "pic3"),
    Msg(id: 3, name: "Chris H", msg: "Hey", date: "10/18/21",img: "pic4"),
    Msg(id: 4, name: "Lina T", msg: "yeah I'm really enjoying the class", date: "10/17/21",img: "pic5"),
    Msg(id: 5, name: "Kate G", msg: "we could meet at the library", date: "10/17/21",img: "pic6"),
    Msg(id: 6, name: "Frank S", msg: "I'll take a look", date: "10/16/21",img: "pic7"),
    Msg(id: 7, name: "James O", msg: "Hello", date: "10/12/21",img: "pic8"),
    Msg(id: 8, name: "Becca", msg: "How are you?", date: "10/12/21",img: "pic9"),
    Msg(id: 9, name: "Brian L", msg: "awesome stuff!", date: "10/11/21",img: "pic10"),
    Msg(id: 10, name: "Julia U", msg: "Are you ready to go?", date: "09/24/21",img: "pic11"),
    Msg(id: 11, name: "Lauren A", msg: "glad you got it done", date: "09/16/21",img: "pic12"),
    
]

var data = [
]



var contact_list:[Contact] = Contact.fetchContacts()

