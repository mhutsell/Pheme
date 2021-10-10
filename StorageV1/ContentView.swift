//
//  ContentView.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
//	sort message with timeCreated, can be changed to different entity to test CRUD functions
//	to test other entities, they need to be fetchrequested as well
//    @FetchRequest(
////    	sort the messages by its timeCreated
//        sortDescriptors: [NSSortDescriptor(keyPath: \Message.timeCreated, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Message>

    @FetchRequest(
//    	sort the identities by its nickname
        sortDescriptors: [NSSortDescriptor(keyPath: \Identity.nickname, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Identity>

//	add more var here to test create with multiple input item
    @State private var newItem = ""

    var body: some View {
        NavigationView {
			List {
//				Section(header: Text("Add message")) {
				Section(header: Text("Add identity")) {
					HStack{
//						add more TextField here to test create with multiple input item
//						TextField("New message", text: self.$newItem)
						TextField("New nickname", text: self.$newItem)
						Button(action: {
//						change the function here to test other CRUD
//							creatMessage(body: self.newItem)
//							createIdentity(nickname: self.newItem)
						}){
							Image(systemName: "plus.circle.fill")
								 .foregroundColor(.blue)
								 .imageScale(.large)
						}
					}
				}
				ForEach(items) { item in
//				change what to show here to check succeeful creation
//					Text(item.messageBody ?? "Unspecified")
//					Text(item.publicKey?.keyBody ?? "Unspecified")
// TODO: change show items to id attibutes
				}.onDelete(perform: deleteItem(offsets:))
			}
			.navigationTitle("Items")
		}
    }
//	sample functions for creation an entity
    private func createMessage(body: String) {
        withAnimation {
            let newMessage = Message(context: viewContext)
            newMessage.timeCreated = Date()
            newMessage.messageBody = body
            saveContext()
        }
    }
    
    private func createIdentity(nickname: String) {
		withAnimation {
            let newIdentity = Identity(context: viewContext)
            newIdentity.nickname = nickname
			let result = createRSAKeyPair()
			createPrivateKey(kd: result.private, id: newIdentity)
			createPublicKey(kd: result.public, id: newIdentity, type: 0)
            saveContext()
        }
	}

//	generate new rsa key pair with random data
	private func createRSAKeyPair() -> (public:Data, private:Data) {
		let publicKeyAttr: [NSObject: NSObject] = [
            kSecAttrIsPermanent:true as NSObject,
            kSecAttrApplicationTag:"com.pheme.app.Rsa.public".data(using: String.Encoding.utf8)! as NSObject,
            kSecClass: kSecClassKey,
            kSecReturnData: kCFBooleanTrue]
		let privateKeyAttr: [NSObject: NSObject] = [
			kSecAttrIsPermanent:true as NSObject,
			kSecAttrApplicationTag:"com.pheme.app.Rsa.private".data(using: String.Encoding.utf8)! as NSObject,
			kSecClass: kSecClassKey,
			kSecReturnData: kCFBooleanTrue]
		
		var publicKeySec, privateKeySec: SecKey?
		let keyattribute = [
			kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
			kSecAttrKeySizeInBits as String : 4096
		] as CFDictionary
		SecKeyGeneratePair(keyattribute, &publicKeySec, &privateKeySec)
		var resultPublicKey: AnyObject?
		var resultPrivateKey: AnyObject?
		SecItemCopyMatching(publicKeyAttr as CFDictionary, &resultPublicKey)
		SecItemCopyMatching(privateKeyAttr as CFDictionary, &resultPrivateKey)
		let publicKey = resultPublicKey as! Data
		let privateKey = resultPrivateKey as! Data
		return (publicKey, privateKey)
	}
	
	private func createPrivateKey(kd: Data, id: Identity) {
		withAnimation {
            let newKey = PrivateKey(context: viewContext)
            newKey.keyBody = kd
            newKey.id = id
            saveContext()
        }
	}
	
//	need at least one of id, contact, eSender, mSender
//	TODO: handle error cases
	private func createPublicKey(kd: Data, id: Identity? = nil, contact: Contact? = nil, eSender: Encrypted? = nil, mSender: Message? = nil, type: Int) {
		withAnimation {
            let newKey = PublicKey(context: viewContext)
            newKey.keyBody = kd
            switch type {
            case 0:
				newKey.id = id
			case 1:
				newKey.contact = contact
			case 2:
				newKey.encryptedSender = eSender
			case 3:
				newKey.messageSender = mSender
			default:
				newKey.id = id
			}
            
            saveContext()
        }
	}
    
//    sample function to delete entity by swiping to left, more delete functions are needed like deleteMessage() below
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
//		sample functions for creation an entity
	private func deleteMessage(item: Message) {
		withAnimation {
			viewContext.delete(item)
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
