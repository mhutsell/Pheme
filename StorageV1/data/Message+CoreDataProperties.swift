//
//  Message+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/24/21.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var messageBody: String?
    @NSManaged public var messageType: Int16
    @NSManaged public var timeCreated: Date?
    @NSManaged public var sentByMe: Bool
    @NSManaged public var contact: Contact?

}

extension Message {


	//	create message
    static func createMessageFor(body: String, contact: Contact) {
       let newMessage = Message(context: PersistenceController.shared.container.viewContext)
		newMessage.timeCreated = Date()
		newMessage.messageBody = body
		newMessage.contact = contact
		newMessage.sentByMe = true
		newMessage.encryptAndQueue()
    }

    
	//	encrypt the message "I" create for sending to contact
	//	TODO: only checked with encryption/decryption with my own key paris, need to test with using the contact's
	func encryptAndQueue() {
		let identity = Identity.fetchIdentity()
		let newEncrypted = Encrypted(context: PersistenceController.shared.container.viewContext)
		newEncrypted.identity = identity
		newEncrypted.receiverId = self.contact!.id
		newEncrypted.senderId = identity.id
		newEncrypted.messageType = self.messageType
		newEncrypted.timeCreated = self.timeCreated
		newEncrypted.senderKey = identity.publicKey
		newEncrypted.senderNickname = identity.nickname
		newEncrypted.encryptedBody = Message.encryptToData(publicKey: self.contact!.theirKey!.dataToKey(), msBody: self.messageBody!)
		PersistenceController.shared.save()
	}
	
	// encrypt string with public key and return the converted data
	static func encryptToData(publicKey: SecKey, msBody: String) -> Data {
		let bodyData: CFData = msBody.data(using: .utf8)! as CFData
		var error: Unmanaged<CFError>?
		let encryptedBody: Data = SecKeyCreateEncryptedData(publicKey, SecKeyAlgorithm.rsaEncryptionOAEPSHA256, bodyData, &error)! as Data
		return encryptedBody
	}
	
    static func sortByDate(list: [Message]) -> [Message] {
        var returnList: [Message] = list
        return  returnList.sorted{ $0.timeCreated! > $1.timeCreated! }
    }
	//	delete
	func delete() {
		PersistenceController.shared.container.viewContext.delete(self)
	}

}

extension Message : Identifiable {

}
