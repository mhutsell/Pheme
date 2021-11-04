//
//  ContentView.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    
//	sort message with timeCreated, can be changed to different entity to test CRUD functions
//	to test other entities, they need to be fetchrequested as well
//    @FetchRequest(
////    	sort the messages by its timeCreated
//        sortDescriptors: [NSSortDescriptor(keyPath: \Message.timeCreated, ascending: true)],
//        animation: .default)
//    private var messages: FetchedResults<Message>

    @FetchRequest(
//    	sort the identities by its nickname
        sortDescriptors: [NSSortDescriptor(keyPath: \Identity.nickname, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Identity>

//	add more var here to test create with multiple input item
    @State private var newItem = ""
    @State private var newMessage = ""
    @State private var encrypted = ""
	@State private var decrypted = ""

    var body: some View {
        NavigationView {
			List {
				Section(header: Text("Add identity")) {
					HStack{
//						add more TextField here to test create with multiple input item
						TextField("New nickname", text: self.$newItem)
						Button(action: {
//						change the function here to test other CRUD
							Identity.createIdentity(nickname: self.newItem)
//							let id = Identity.fetchIdentity()
//							newMessage = id.nickname!
						}){
							Image(systemName: "plus.circle.fill")
								 .foregroundColor(.blue)
								 .imageScale(.large)
						}
					}
				}
				// need to at least create one identity
				Section(header: Text("raw, encrypted, and decrypted message")) {
					HStack{
//						add more TextField here to test create with multiple input item
						TextField("New message", text: self.$newMessage)
						Button(action: {
//						change the function here to test other CRUD
//							let result = encryptionTest(testString: self.newMessage, id: items[0])
//							self.decrypted = result.decrypted
//							self.encrypted = result.encrypted
						}){
							Image(systemName: "plus.circle.fill")
								 .foregroundColor(.blue)
								 .imageScale(.large)
						}
					}
				}
//                ForEach(items) { item in
//                //    change what to show here to check succeeful creation
//                //     Text(item.messageBody ?? "Unspecified")
//                     Text(item.publicKey?.keyBody ?? "Unspecified")
//                     Text(item.privateKey?.keyBody ?? "Unspecified")
//                // TODO: change show items to id attibutes
//                    }.onDelete(perform: deleteItem(offsets:))
//				Text(self.newMessage)
				ForEach(items) { item in
					Text(item.nickname ?? "Unspecified")
////                    Text(myInfo().id!)
////                    Text(myInfo().key!)
//                    Text(myInfo().nickname!)
//					Text(self.newMessage)
//					Text(self.encrypted)
//					Text(self.decrypted)
				}.onDelete(perform: deleteItem(offsets:))
				


//                test for encryption and decryption
//                let result = encryptionTest()
//                Text(result.testString)
//
//                Text(String(result.decrypted.count))
//                Text(result.decrypted)
                
			

			}
			.navigationTitle("Items")
		}
    }

    
//    TODO: Ken needs to finish it soon
    // attemp to sort encrypted messages by date in ascending order

    private func sortAnddeleteEncrypted(deleteNumber: Int) {
//        let context = _viewContext
//        let fetchRequest = NSFetchRequest<Encrypted>(entityName: "Encrypted")
//        let sort = NSSortDescriptor(key: #keyPath(Encrypted.timeCreated), ascending: true)
//        fetchRequest.sortDescriptors = [sort]
//        do {
//            encrypted = try context.fetch(fetchRequest)
//        } catch {
//            print("Cannot fetch encrypted messages")
//        }
        

//        @FetchRequest(
//            sortDescriptors: [NSSortDescriptor(key: #keyPath(Encrypted.timeCreated), ascending: true)],
//            animation: .default)
//        var encryptedMessages: FetchedResults<Encrypted>

        
        //count the numebr of items in the struct 'encrypted'
//        if count(encryptedMessages) >= 50 {
//            encryptedMessages.dropFirst(deleteNumber)
//        }
        //TO-DO: check if encrypted messages in the core data are correctly deleted
    }

    
    
// attemp to delete encrypted messages not belonging to a user when the number of messages exceeds 50
    
//    TODO: need to reconsider qr -> includes both one's public key and uuis (by concatenation?)
//    private func createContact() {}
    
//    private func encryptionTest(testString: String = "Hello World", id: Identity) -> (testString:String,  encrypted: String, decrypted: String) {
//
//        var error: Unmanaged<CFError>?
//
//		let attribute = [
//			kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//			kSecAttrKeyClass as String : kSecAttrKeyClassPublic
//		]
//
//
//        let keyString: String = myInfo().key!
//
//        let pubKey: SecKey = SecKeyCreateWithData(Data(base64Encoded: keyString)! as CFData, attribute as CFDictionary, &error)! as SecKey
//
////        let pubKey: SecKey = SecKeyCreateWithData(Data(base64Encoded: myPublicKeyString())! as CFData, attribute as CFDictionary, &error)! as SecKey
//
////        let pubKey: SecKey = SecKeyCreateWithData(id.publicKey!.keyBody! as CFData, attribute as CFDictionary, &error)! as SecKey
//
//		let priattribute = [
//			kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//			kSecAttrKeyClass as String : kSecAttrKeyClassPrivate
//		]
//		let priKey: SecKey = SecKeyCreateWithData(id.privateKey!.keyBody! as CFData, priattribute as CFDictionary, &error)! as SecKey
//
//        let bodyData: CFData = testString.data(using: .utf8)! as CFData
//
//		let encrypted: Data = SecKeyCreateEncryptedData(pubKey, SecKeyAlgorithm.rsaEncryptionOAEPSHA256, bodyData, &error)! as Data
//		let decrypted: Data = SecKeyCreateDecryptedData(priKey, SecKeyAlgorithm.rsaEncryptionOAEPSHA256, encrypted as CFData, &error)! as Data
//		// TODO: handle nil case (if need to try decrypting every message)
//
//        let str = String(decoding: decrypted, as: UTF8.self)
//
//        return (testString, encrypted.base64EncodedString(), str)
////        return (testString,  str)
//    }
    
    

	

		
	
//	retrive the latest message of all contacts
//	TODO: frontend needs to add the Msg struct
//	private func fetchLatests() -> [Msg] {
//		withAnimation {
//			let fr: NSFetchRequest<Contact> = Contact.fetchRequest()
//			fr.sortDescriptors = [NSSortDescriptor(keyPath: \Contact.timeLatest, ascending:false)]
//			do {
//				let contacts = try viewContext.fetch(fr)
////				var data = [Msg]()
//				for (ct, idx) in contacts.enumerated() {
//					let fr2: NSFetchRequest<Message> = Message.fetchRequest()
//					fr2.predicate = NSPredicate(
//						format: "contact LIKE %@", ct
//					)
//					fr2.fetchLimit = 1
//					fr2.sortDescriptors = [NSSortDescriptor(keyPath: \Message.timeCreated, ascending:false)]
//					do {
//						let ms = try viewContext.fetch(fr2).first
//						return Msg(id: idx, name: ct.nickname, msg: ms?.messageBody, date: ms?.timeCreated)
////						let ms = try viewContext.fetch(fr2).first  ??
////						TODO: what to send if it's a newly added contact without conversation yet>
//					} catch {let nsError = error as NSError
//						fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//					}
//				}
//			} catch {let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//			}
//		}
//	}
	
//	retrieve messages with a particular contact
//	private func retrieveMessages(ct: Contact) {}
    
//  sample function to delete entity by swiping to left, more delete functions are needed like deleteMessage() below
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    	
    
//    used at the end of all CRUD functions
    private func saveContext() {
		do {
                try viewContext.save()
            } catch {let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
	}
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
