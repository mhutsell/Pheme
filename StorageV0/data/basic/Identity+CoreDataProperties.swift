//
//  Identity+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 10/6/21.
//
//

import Foundation
import CoreData


extension Identity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identity> {
        return NSFetchRequest<Identity>(entityName: "Identity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var nickname: String?
    @NSManaged public var password: Int64
    @NSManaged public var contacts: NSSet?
    @NSManaged public var notMyMessage: NSSet?
    @NSManaged public var privateKey: Key?
    @NSManaged public var publicKey: Key?

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

// MARK: Generated accessors for notMyMessage
extension Identity {

    @objc(addNotMyMessageObject:)
    @NSManaged public func addToNotMyMessage(_ value: EncryptedMessage)

    @objc(removeNotMyMessageObject:)
    @NSManaged public func removeFromNotMyMessage(_ value: EncryptedMessage)

    @objc(addNotMyMessage:)
    @NSManaged public func addToNotMyMessage(_ values: NSSet)

    @objc(removeNotMyMessage:)
    @NSManaged public func removeFromNotMyMessage(_ values: NSSet)

}

extension Identity : Identifiable {

}
