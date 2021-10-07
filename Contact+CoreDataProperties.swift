//
//  Contact+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 10/6/21.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var hasMyKey: Bool
    @NSManaged public var id: Int64
    @NSManaged public var nickname: String?
    @NSManaged public var belongToIdentity: Identity?
    @NSManaged public var messages: NSSet?
    @NSManaged public var publicKey: Key?

}

// MARK: Generated accessors for messages
extension Contact {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension Contact : Identifiable {

}
