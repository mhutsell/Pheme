//  Pheme
//  Message, Contact, Setttings Page

import SwiftUI
import CoreImage.CIFilterBuiltins
import CoreData
import CodeScanner


// Create the base view
//@available(iOS 14.0, *)
struct ContentView: View {
    
    @EnvironmentObject private var identity: Identity
    @EnvironmentObject private var contacts: Contacts
    var username : String
    
    @State var index = 1
    @State var expand = true
    
    var body: some View {

        if #available(iOS 14.0, *) {
            Home(username: self.username)
                .environmentObject(identity)
                .environmentObject(contacts)
                .navigationBarBackButtonHidden(true)
        } else {
            // Fallback on earlier versions
        }
        
//        TabView{
//            MessageView(username: self.username, expand: self.$expand)
//                .opacity(self.index == 0 ? 1 : 0)
//                .tabItem {
//                    VStack {
//                        Image(systemName: "message.fill")
//                        Text("Channels")
//                    }
//                }
//
//            ContactsView(expand: self.$expand)
//                .opacity(self.index == 1 ? 1 : 0)
//                .tabItem {
//                    VStack {
//                        Image(systemName: "person.circle.fill")
//                        Text("Profile")
//                    }
//                }
//            SettingsView(username: self.username)
//                .opacity(self.index == 2 ? 1 : 0)
//                .tabItem {
//                    VStack {
//                        Image(systemName: "gear")
//                        Text("Settings")
//                    }
//                }
//
//
//        }
//        .environmentObject(identity)
//        .environmentObject(contacts)
        
    }
}

@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(username: "KunalSuri")
    }
}


