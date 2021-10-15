//
//  ContentView.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//

import SwiftUI
import CoreData
import CryptorRSA

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
//                ForEach(items) { item in
//                //    change what to show here to check succeeful creation
//                //     Text(item.messageBody ?? "Unspecified")
//                     Text(item.publicKey?.keyBody ?? "Unspecified")
//                     Text(item.privateKey?.keyBody ?? "Unspecified")
//                // TODO: change show items to id attibutes
//                    }.onDelete(perform: deleteItem(offsets:))
                
                let result = encryptionTest()
                Text(result.testString)

                Text(String(result.decrypted.count))
                Text(result.decrypted)
                
                let characters = Array(result.decrypted)
                
                

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
    
    private func encryptionTest() -> (testString:String,  decrypted: String) {
        let testString = "Hello World"
        
        var publicKeySec, privateKeySec: SecKey?
        let keyattribute = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String : 2048
        ] as CFDictionary
        SecKeyGeneratePair(keyattribute, &publicKeySec, &privateKeySec)
        
        let bodyData: CFData = testString.data(using: .utf8)! as CFData
        
        var error: Unmanaged<CFError>?
        
        let encrypted = SecKeyCreateEncryptedData(publicKeySec!, SecKeyAlgorithm.rsaEncryptionOAEPSHA1, bodyData, &error)
        
        
        
//        let encryptedCF: CFData = encrypted as CFData
        
        let decrypted: Data = SecKeyCreateDecryptedData(privateKeySec!, SecKeyAlgorithm.rsaEncryptionOAEPSHA1, encrypted!, &error)! as Data
        
        let str = String(decoding: decrypted, as: UTF8.self)
        
//        return (testString, encrypted.base64EncodedString(), str)
        return (testString,  str)
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
	private func createRSAKeyPair() -> (public:String, private:String) {
		var publicKeySec, privateKeySec: SecKey?
		let keyattribute = [
			kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
			kSecAttrKeySizeInBits as String : 2048
		] as CFDictionary
		SecKeyGeneratePair(keyattribute, &publicKeySec, &privateKeySec)
		
		var error: Unmanaged<CFError>?
		let dataPub = SecKeyCopyExternalRepresentation(publicKeySec!, &error) as Data?
		let dataPri = SecKeyCopyExternalRepresentation(privateKeySec!, &error) as Data?
		return (dataPub!.base64EncodedString(), dataPri!.base64EncodedString())
	}
	
	private func createPrivateKey(kd: String, id: Identity) {
		withAnimation {
            let newKey = PrivateKey(context: viewContext)
            newKey.keyBody = kd
            newKey.id = id
            saveContext()
        }
	}
	
//	need at least one of id (type 0, default), contact (type 1), eSender (type 2), mSender (type 3)
//	TODO: handle error cases
	private func createPublicKey(kd: String, id: Identity? = nil, contact: Contact? = nil, eSender: Encrypted? = nil, mSender: Message? = nil, type: Int = 0) {
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
	
//	save received encrypted
//	TODO: now assuming it's not mine, need to decrypt if possible
	private func createEncrypted(received: Encrypted, id: Identity) {
		withAnimation {
			received.id = id
		}
	}
	
//	encrypt the message "I" create for sending to contact
//	private func createEncryptedFor(ms: Message, id: Identity, contact: Contact) {
//		withAnimation {
//			let newEncrypted = Encrypted(context: viewContext)
//			newEncrypted.id = id
//			newEncrypted.messageType = ms.messageType
//			do {
//				let publicKey = try CryptorRSA.createPublicKey(withBase64: contact.theirKey!.keyBody!)
//				let bodyData: Data = ms.messageBody!.data(using: .utf8)!
//				let plaintext = CryptorRSA.createPlaintext(with: bodyData)
//				let encryptedData = try plaintext.encrypt(with: publicKey, algorithm: .sha1)
//				// TODO: resolve encrypt failure, might give up usgin CryptorRSA but refer to
//				// https://medium.com/@vaibhav.pmeshram/creating-and-dismantling-rsa-key-in-seckey-swift-ios-7b5077e41244
//				// and https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/using_keys_for_encryption
//			} catch {
//				print(error)
//			}
//		}
//	}
	
    
//  sample function to delete entity by swiping to left, more delete functions are needed like deleteMessage() below
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
