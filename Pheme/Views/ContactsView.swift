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
    
    @Binding var expand : Bool
	@ObservedObject private var contacts = Contacts.sharedInstance

	func nn (lhs: Contact2, rhs: Contact2) -> Bool {
        return lhs.nickname < rhs.nickname
    }
    
    var contact_arr = 0
    var body : some View{
        VStack(spacing: 0) {
            
            contactTopView(expand: self.$expand)
                .zIndex(25)
            
			List(Array(contacts.contacts.values.sorted(by: nn)), id:\.id){i in
                            if #available(iOS 14.0, *) {
                                NavigationLink(destination: ChatView(contactId: i.id)) {
                                    cellContactView(contactId: i.id)
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
            }       .padding(.top, 5)
                    .background(Color.white)
                    .clipShape(shape())
                    .offset(y : -25)
            }
    }
    

struct cellContactView : View {
    
	@ObservedObject private var contacts = Contacts.sharedInstance
	@State var showingAlert = false
    var contactId: UUID

    @State var next: Bool = false
    
    var body : some View{
        HStack(spacing: 12){
            if contacts.contacts[contactId] != nil {
				Image(systemName:"person.crop.circle.fill")
				.resizable()
				.frame(width: 55, height: 55)
				.foregroundColor(Color("Color"))
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
				
				VStack(alignment: .leading, spacing: 12) {
				
					Text(contacts.contacts[contactId]!.nickname)
				}
				
				Spacer(minLength: 0)
				
				VStack{
					Spacer()
				}
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
