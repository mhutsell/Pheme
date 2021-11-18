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
            if (!Identity.hasIdentity()) {
                Identity.createIdentity(nickname: "TEMPORARY")
            }
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
        PersistenceController.shared.save()
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
		PersistenceController.shared.save()
	}
	
	//  return a tuple for showing publickey, nickname, UUID, for QR
    static func myKey() -> String {
        let identity = Identity.fetchIdentity()
        return identity.publicKey!.keyBody!.base64EncodedString()
    }
    
    static func myName() -> String {
        let identity = Identity.fetchIdentity()
        return identity.nickname!
    }
    
    static func myID() -> String {
        let identity = Identity.fetchIdentity()
        return identity.id!.uuidString
    }
    
	//	update the max number of encrypte stored
	static func updateMaxEncrypted(max: Int16) {
		self.fetchIdentity().maxEncrypted = max
		PersistenceController.shared.save()
	}
	
	// retrieve my own private key
	static func retrievePrivateKey() -> SecKey {
		return self.fetchIdentity().privateKey!.dataToKey()
	}
	
	//	delete
	func delete() {
		PersistenceController.shared.container.viewContext.delete(self)
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
