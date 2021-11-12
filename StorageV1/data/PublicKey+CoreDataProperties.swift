//
//  PublicKey+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/20/21.
//
//

import Foundation
import CoreData


extension PublicKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PublicKey> {
        return NSFetchRequest<PublicKey>(entityName: "PublicKey")
    }

    @NSManaged public var keyBody: Data?
    @NSManaged public var contact: Contact?
    @NSManaged public var encryptedSender: Encrypted?
    @NSManaged public var identity: Identity?

}

extension PublicKey {

	// convert data to public key
	func dataToKey() -> SecKey {
		let attribute = [
			kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
			kSecAttrKeyClass as String : kSecAttrKeyClassPublic
		]
		var error: Unmanaged<CFError>?
		let pubKey: SecKey = SecKeyCreateWithData(self.keyBody! as CFData, attribute as CFDictionary, &error)!
		return pubKey
	}
	
	// create public key called by createContact()
	static func createPublicKey(key: String) -> PublicKey {
		let newKey = PublicKey(context: PersistenceController.shared.container.viewContext)
		newKey.keyBody = Data(base64Encoded: key, options: .ignoreUnknownCharacters)
        PersistenceController.shared.save()
        return newKey
	}

}

extension PublicKey : Identifiable {

}
