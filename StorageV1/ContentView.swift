//  Pheme
//  Message, Contact, Setttings Page

import SwiftUI
import CoreImage.CIFilterBuiltins
import CoreData
import CodeScanner


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
                    
                    Messages(username: self.username, expand: self.$expand).opacity(self.index == 0 ? 1 : 0)
                    
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
    
    var username : String
    @Binding var expand : Bool
    
 //   @FetchRequest(
 //           sortDescriptors: [NSSortDescriptor(keyPath: \Contact.timeLatest, ascending:false)],
 //           animation: .default)
 //       var data: FetchedResults<Contact>
    var data = Contact2.contacts!
    var body : some View{
        VStack(spacing: 0){

            chatTopView(username: self.username, expand: self.$expand)
                .zIndex(25)
            List(data, id:\.nickname){i in

//                if i.id == 0{

                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: ChatView(contact: i)) {
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
               // ii+=1
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

    @State var username: String
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var key = Identity2.myKey()
    var id = Identity2.myID()
    var name = Identity2.myName()
    
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

    var data : Contact2

    var body : some View{

        HStack(spacing: 12){

            Image(systemName:"person.crop.circle.fill")
            .resizable()
            .frame(width: 55, height: 55)
            .foregroundColor(Color("Color"))
            
            VStack(alignment: .leading, spacing: 12) {

          //      Text(data.nickname!)

            //    Text(data.fetchLatestMessageString()).font(.caption)
            }

            Spacer(minLength: 0)

            VStack{
                Text(time())

                Spacer()
            }
        }.padding(.vertical)
    }
    
    func time () -> String {
        let time2 = data.timeLatest!
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        return formatter1.string(from: time2)
    }
}

/*
Everything needed for the Contact page
 - struct Contacts
 - struct contactTopView
*/

struct Contacts : View {
    
    @Binding var expand : Bool
//    @State var contact_list2:[Contact] = contact_list
 //   @FetchRequest(
 //           sortDescriptors: [NSSortDescriptor(keyPath: \Contact.timeLatest, ascending:false)],
 //           animation: .default)
 //       var contact_list: FetchedResults<Contact>
    var contact_list = Contact2.contacts!

    var contact_arr = 0
    var body : some View{
        
        VStack(spacing: 0) {
            
            contactTopView(expand: self.$expand)
                .zIndex(25)
            List(contact_list, id:\.nickname){i in
            
//                        if i.id == 0{
                            
                            if #available(iOS 14.0, *) {
                                NavigationLink(destination: ChatView(contact: i)) {
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


struct cellContactView : View {
    
    var contact_list : Contact2
    @State var next: Bool = false
    
    var body : some View{
        HStack(spacing: 12){
            
            Image(systemName:"person.crop.circle.fill")
            .resizable()
            .frame(width: 55, height: 55)
            .foregroundColor(Color("Color"))
//
            VStack(alignment: .leading, spacing: 12) {
            
                Text("FFFFFFFFFFFFFFFFFFFFFFFF")
                
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
    
    var key = Identity2.myKey()
    var id = Identity2.myID()
    var name = Identity2.myName()
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    @State private var isShowingScanner = false
    var body : some View{
        
        return VStack {
        
            Image(uiImage: generateQRCode2(from: "\(self.name)\n\(self.key)\n\(self.id)"))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
            
            Spacer()
            
            Button(action: {
                self.isShowingScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                                    .resizable()
                                    .frame(width: 75, height: 75)
                                    .padding()
                                    .foregroundColor(Color("Color"))
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes:[.qr], completion:self.handleScan)
            
            }
        }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color.white)
        .clipShape(shape())
        .animation(.default)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .padding(.bottom)
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
            case .success(let code):
                let details = code.components(separatedBy: "\n")
                guard details.count == 3 else { return }

                Contact2.createContact(nn: details[0], keybody: details[1], id: details[2])
                
            case .failure(let error):
                print("Scanning failed")
        }
    }
    
    func generateQRCode2(from string: String) -> UIImage {
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

//var contact_list:[Contact] = Contact.fetchContacts()


