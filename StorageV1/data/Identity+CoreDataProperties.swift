//
//  Identity+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/31/21.
//
//

import Foundation
import CoreData

extension Identity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identity> {
        return NSFetchRequest<Identity>(entityName: "Identity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nickname: String?
    @NSManaged public var maxEncrypted: Int16
    @NSManaged public var contacts: NSSet?
    @NSManaged public var notMine: NSSet?
    @NSManaged public var privateKey: PrivateKey?
    @NSManaged public var publicKey: PublicKey?
	
 }
 
extension Identity {
	
	//	fetch the identity (assume have the only one)
	static func fetchIdentity() -> Identity {
		let fr: NSFetchRequest<Identity> = Identity.fetchRequest()
        fr.fetchLimit = 1
        do {
			let identity = (try PersistenceController.shared.container.viewContext.fetch(fr).first)!
            return identity
        } catch {let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}
    
	
	//	return if there is an identity
	//	TODO: untested yet
	static func hasIdentity() -> Bool {
		let fr: NSFetchRequest<Identity> = Identity.fetchRequest()
        fr.fetchLimit = 1
        do {
			let count = try PersistenceController.shared.container.viewContext.count(for: fr)
            return count == 1
        } catch {let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}
	
	//	no check for existing identity
	static func createIdentity(nickname: String) {
		let newIdentity = Identity(context: PersistenceController.shared.container.viewContext)
		newIdentity.nickname = nickname
		newIdentity.id = UUID()
		newIdentity.maxEncrypted = 50
		newIdentity.createRSAKeyPair()
//        let persistenceController = PersistenceController.shared
//        persistenceController.save()
	}
	
	//	generate new rsa key pair with random data for the identity
	//	merge create private and publickey into this func because they won't be used otherwise
	func createRSAKeyPair() {
		var publicKeySec, privateKeySec: SecKey?
		let keyattribute = [
			kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
			kSecAttrKeySizeInBits as String : 2048
		] as CFDictionary
		SecKeyGeneratePair(keyattribute, &publicKeySec, &privateKeySec)
		
		var error: Unmanaged<CFError>?
		let priKey = PrivateKey(context: PersistenceController.shared.container.viewContext)
		priKey.keyBody = SecKeyCopyExternalRepresentation(privateKeySec!, &error) as Data?
		priKey.identity = self
		let pubKey = PublicKey(context: PersistenceController.shared.container.viewContext)
		pubKey.keyBody = SecKeyCopyExternalRepresentation(publicKeySec!, &error) as Data?
		pubKey.identity = self
	}
	
	//  return a tuple for showing publickey, nickname, UUID, for QR
    static func myInfo() -> (key: String, nickname: String, id: String) {
        let identity = Identity.fetchIdentity()
		return (identity.publicKey!.keyBody!.base64EncodedString(), identity.nickname!, identity.id!.uuidString)
    }
	
	//	update the max number of encrypte stored
	static func updateMaxEncrypted(max: Int16) {
		self.fetchIdentity().maxEncrypted = max
	}
	
	// retrieve my own private key
	static func retrievePrivateKey() -> SecKey {
		return self.fetchIdentity().privateKey!.dataToKey()
	}
	
	
}

// MARK: Generated accessors for contacts
extension Identity {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

// MARK: Generated accessors for notMine
extension Identity {

    @objc(addNotMineObject:)
    @NSManaged public func addToNotMine(_ value: Encrypted)

    @objc(removeNotMineObject:)
    @NSManaged public func removeFromNotMine(_ value: Encrypted)

    @objc(addNotMine:)
    @NSManaged public func addToNotMine(_ values: NSSet)

    @objc(removeNotMine:)
    @NSManaged public func removeFromNotMine(_ values: NSSet)

}

extension Identity : Identifiable {

}
