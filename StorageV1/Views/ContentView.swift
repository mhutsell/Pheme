//  Pheme
//  Message, Contact, Setttings Page

import SwiftUI
import CoreImage.CIFilterBuiltins
import CoreData
import CodeScanner
import UserNotifications


// Create the base view
//@available(iOS 14.0, *)
struct ContentView: View {
    
    var username : String
    
    @State var index = 1
    @State var expand = true
    
    var body: some View {

        if #available(iOS 14.0, *) {
            Home(username: self.username)
                .navigationBarBackButtonHidden(true)
        } else {
        }
        
    }
}

@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(username: "KunalSuri")
    }
}


