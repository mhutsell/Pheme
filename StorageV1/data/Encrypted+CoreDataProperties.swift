//
//  Encrypted+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/20/21.
//
//

import Foundation
import CoreData


extension Encrypted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Encrypted> {
        return NSFetchRequest<Encrypted>(entityName: "Encrypted")
    }

    @NSManaged public var encryptedBody: Data?
    @NSManaged public var messageType: Int16
    @NSManaged public var receiverId: UUID?
    @NSManaged public var senderId: UUID?
    @NSManaged public var timeCreated: Date?
    @NSManaged public var senderNickname: String?
    @NSManaged public var identity: Identity?
    @NSManaged public var senderKey: PublicKey?

}

extension Encrypted {

    func to_json() -> String{
        var to_return = "{{{{{\(self.encryptedBody)"
        to_return += "|||||\(self.messageType)"
        to_return += "|||||\(self.receiverId)"
        to_return += "|||||\(self.senderId)"
        to_return += "|||||\(self.timeCreated)"
        to_return += "|||||\(self.senderNickname)"
        to_return += "|||||\(self.senderKey!.keyBody)" + "|||||}}}}}"
        return to_return
    }
    
    static func from_json(incomingMessage: String){
        var str_msgs = "\(incomingMessage)"
        str_msgs.remove(at: str_msgs.startIndex)
        str_msgs.remove(at: str_msgs.endIndex)
        let split_msgs:[String] = str_msgs.components(separatedBy: "{{{{{")
        let date_formatter = DateFormatter()
        firstFor: for json_msg in split_msgs{
            let split_comps:[String] = json_msg.components(separatedBy: "|||||")
            let encryptedBody: Data? = split_comps[1].data(using: .utf8)
            let messageType: Int16? = Int16(split_comps[2])
            let receiverId: UUID? = UUID(uuidString: split_comps[3])
            let senderId: UUID? = UUID(uuidString: split_comps[4])
            let timeCreated: Date? = date_formatter.date(from: split_comps[5])
            let senderNickname: String? = split_comps[6]
            let senderKey: String? = split_comps[7]
            
            let curr_s_contact = Contact.searchOrCreate(nn: senderNickname!, key: PublicKey.createPublicKey(key: senderKey!), id: senderId!)
            let curr_msgs: [Message] = curr_s_contact.fetchMessages()
            for curr_msg in curr_msgs{
                if (curr_msg.timeCreated == timeCreated){
                    continue firstFor
                }
            }
            curr_s_contact.addEncrypted(encryptedBody: encryptedBody, messageType: messageType!, receiverId: receiverId!, senderId: senderId!, timeCreated: timeCreated!, senderNickname: senderNickname, senderKey: senderKey)
        }
        
    }
    
	//	fetch the list of all encrypted
	static func fetchEncrypted(ascending: Bool = false) -> [Encrypted] {
        let fr: NSFetchRequest<Encrypted> = Encrypted.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(keyPath: \Encrypted.timeCreated, ascending:ascending)]
        do {
            let ecs = try PersistenceController.shared.container.viewContext.fetch(fr)
            return ecs
        } catch {let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    //	autodelete encrypted based on the id.maxEncrypted
    static func checkMaxEncrypted() {
        let listSize = Encrypted.fetchEncrypted().count
        let identity = Identity.fetchIdentity()
        if (listSize > identity.maxEncrypted) {
			let ecs = Encrypted.fetchEncrypted(ascending: true)
            ecs[0].delete()
        }
    }
	
	//	search if this encrypted is for me and search the contact who send this message
	//	if no existing contact exists, create contact
	//	TODO: need func for input->encrypted
	//  TODO: check max encrypted
	//	TODO: untested yet
	func checkAndSearch() {
		let identity = Identity.fetchIdentity()
		if (self.receiverId != identity.id) {
			self.identity = identity
			Encrypted.checkMaxEncrypted()
		} else {
			let ct = Contact.searchOrCreate(nn: self.senderNickname!, key: self.senderKey!, id: self.senderId!)
			self.decryptTo(contact: ct)
			self.delete()
		}
	}
	
	//	decrypt the encrypt with my key
	func decryptTo(contact: Contact) {
		let newMessage = Message(context: PersistenceController.shared.container.viewContext)
		newMessage.contact = contact
		newMessage.timeCreated = self.timeCreated
		newMessage.messageBody = Encrypted.decryptToString(privateKey: Identity.retrievePrivateKey(), body: self.encryptedBody!)
		newMessage.sentByMe = false
        if (contact.timeLatest! < self.timeCreated!) {
                    contact.timeLatest = self.timeCreated
        }
		PersistenceController.shared.save()
	}
	
	// decrypt body with private key and return the converted string
	static func decryptToString(privateKey: SecKey, body: Data) -> String {
		var error: Unmanaged<CFError>?
		let decryptedBody: Data = SecKeyCreateDecryptedData(privateKey, SecKeyAlgorithm.rsaEncryptionOAEPSHA256, body as CFData, &error)! as Data
		return String(decoding: decryptedBody, as: UTF8.self)
	}

	//	delete
	func delete() {
		PersistenceController.shared.container.viewContext.delete(self)
	}
}


extension Encrypted : Identifiable {

}
