//
//  ContactsView.swift
//  StorageV1
//
//  Created by Chen Gong on 11/23/21.
//

import SwiftUI

/*
Everything needed for the Contact page
 - struct Contacts
 - struct contactTopView
*/

struct ContactsView : View {
    
    @EnvironmentObject private var identity: Identity
    @EnvironmentObject private var contacts: Contacts
    @Binding var expand : Bool
//    @State var contact_list2:[Contact] = contact_list
 //   @FetchRequest(
 //           sortDescriptors: [NSSortDescriptor(keyPath: \Contact.timeLatest, ascending:false)],
 //           animation: .default)
 //       var contact_list: FetchedResults<Contact>
    

    var contact_arr = 0
    var body : some View{
		let contact_list = Array(contacts.contacts.values)
        VStack(spacing: 0) {
            
            contactTopView(expand: self.$expand)
                .zIndex(25)
            
            List(contact_list, id:\.id){i in
            
//                        if i.id == 0{
                            
                            if #available(iOS 14.0, *) {
                                NavigationLink(destination: ChatView(contactId: i.id)) {
                                    cellContactView(contactId: i.id)
                                        .onAppear{
                                            self.expand = true
                                        }
                                        .onDisappear{
                                            self.expand = false
                                        }
                                        .environmentObject(contacts)
                                
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
    

struct cellContactView : View {
    
    @EnvironmentObject private var identity: Identity
    @EnvironmentObject private var contacts: Contacts
    var contactId: UUID

    @State var next: Bool = false
    
    var body : some View{
        HStack(spacing: 12){
            
            Image(systemName:"person.crop.circle.fill")
            .resizable()
            .frame(width: 55, height: 55)
            .foregroundColor(Color("Color"))
//
            VStack(alignment: .leading, spacing: 12) {
            
                Text(contacts.contacts[contactId]!.nickname)
                
//                Text("@" + contact_list.username).font(.caption)
            }
            
            Spacer(minLength: 0)
            
            VStack{
                
                
                Spacer()
            }

        }.padding(.vertical)
    }
}



struct ContactsView_Previews: PreviewProvider {
    @State static var expand: Bool = true
    static var previews: some View {
        ContactsView(expand: $expand)
    }
}
