//
//  Identity+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 9/29/21.
//
//

import Foundation
import CoreData


extension Identity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identity> {
        return NSFetchRequest<Identity>(entityName: "Identity")
    }

    @NSManaged public var timeCreated: Date?
    @NSManaged public var messages: NSSet?
    @NSManaged public var permanentPrivateKey: Key?
    @NSManaged public var permanentPublicKey: Key?

}

// MARK: Generated accessors for messages
extension Identity {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: NaiveMessage)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: NaiveMessage)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension Identity : Identifiable {

}
