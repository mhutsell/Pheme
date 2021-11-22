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
    @NSManaged public var senderKey: PublicKey?
    @NSManaged public var identity: Identity?
}

extension Encrypted {

    func to_json() -> String{
        var to_return = "{{{{{" + self.encryptedBody!.base64EncodedString()
        to_return += "|||||\(self.messageType)"
        to_return += "|||||\(self.receiverId!)"
        to_return += "|||||\(self.senderId!)"
        to_return += "|||||\(self.timeCreated!)"
        to_return += "|||||\(self.senderNickname!)"
        var our_id = Identity.fetchIdentity()
        //to_return += "|||||\(self.senderKey!.keyBody)" + "|||||}}}}}"
        to_return += "|||||" + our_id.publicKey!.keyBody!.base64EncodedString() + "|||||}}}}}"
        return to_return
    }
    
    static func from_json(incomingMessage: String){
        if BTController.hasReceived{
            return
        }
        lazy var backgroundContext: NSManagedObjectContext = {
            let newbackgroundContext = PersistenceController.shared.container.newBackgroundContext()
            newbackgroundContext.automaticallyMergesChangesFromParent = true
            return newbackgroundContext
        }()
        backgroundContext.performAndWait {
            BTController.hasReceived = true
            var str_msgs = "\(incomingMessage)"
            str_msgs.remove(at: str_msgs.startIndex)
            str_msgs.remove(at: str_msgs.index(str_msgs.endIndex, offsetBy: -1))
            let split_msgs:[String] = str_msgs.components(separatedBy: "{{{{{")
            let date_formatter = DateFormatter()
            date_formatter.locale = Locale(identifier: "en_US_POSIX")
            date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            firstFor: for json_msg in split_msgs{
                if (json_msg == ""){
                    continue
                }
                let split_comps:[String] = json_msg.components(separatedBy: "|||||")
                let encryptedBody: Data? = Data(base64Encoded: split_comps[0], options: .ignoreUnknownCharacters)
                let messageType: Int16? = Int16(split_comps[1])
                let receiverId: UUID? = UUID(uuidString: split_comps[2])
                let senderId: UUID? = UUID(uuidString: split_comps[3])
                let timeCreated: Date? = date_formatter.date(from: split_comps[4])
                let senderNickname: String? = split_comps[5]
                let senderKey: String? = split_comps[6]
                
                // Use encrypted not contact fetch messages - message might not be for us.
                let curr_s_contact = Contact.searchOrCreate(nn: senderNickname!, key: PublicKey.createPublicKey(key: senderKey!, backgroundContext: backgroundContext), id: senderId!, backgroundContext: backgroundContext)
                let curr_msgs: [Message] = curr_s_contact.fetchMessages()
                for curr_msg in curr_msgs{
                    if (curr_msg.timeCreated == timeCreated){
                        continue firstFor
                    }
                }
                var enc = Contact.addEncrypted(encryptedBody: encryptedBody, messageType: messageType!, receiverId: receiverId!, senderId: senderId!, timeCreated: timeCreated!, senderNickname: senderNickname, senderKey: senderKey, backgroundContext: backgroundContext)
                enc.checkAndSearch(backgroundContext: backgroundContext)
            }
            do{
                try backgroundContext.save()
            }
            catch{
                fatalError("Terrible wasn't able to save: \(error)")
            }
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
            var ct = Contact.searchOrCreate(nn: self.senderNickname!, id: self.senderId!)
          //  ct = ct.fetchcontactid(objectid: ct)
			self.decryptTo(contact: ct)
			self.delete()
		}
	}
    
    func checkAndSearch(backgroundContext: NSManagedObjectContext) {
        let identity = Identity.fetchIdentity(backgroundContext: backgroundContext)
        if (self.receiverId != identity.id) {
            self.identity = identity
            Encrypted.checkMaxEncrypted()
        } else {
            var ct = Contact.searchOrCreate(nn: self.senderNickname!, id: self.senderId!, backgroundContext: backgroundContext)
          //  ct = ct.fetchcontactid(objectid: ct)
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
        do {
            try PersistenceController.shared.container.viewContext.save()
        }
        catch{
            fatalError("Blah blah balh")
        }
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
