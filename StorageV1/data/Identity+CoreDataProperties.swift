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
