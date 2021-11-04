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

	//	search if this encrypted is for me and search the contact who send this message
	//	if no existing contact exists, create contact
	//	TODO: need func for input->encrypted
	//  TODO: check max encrypted
	//	TODO: untested yet
	func checkAndSearch() {
		let identity = Identity.fetchIdentity()
		if (self.receiverId != identity.id) {
			self.identity = identity
			//	Identity.checkMaxEncrypted()
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
