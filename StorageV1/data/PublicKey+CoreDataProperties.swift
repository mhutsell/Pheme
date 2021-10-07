//
//  PublicKey+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//
//

import Foundation
import CoreData


extension PublicKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PublicKey> {
        return NSFetchRequest<PublicKey>(entityName: "PublicKey")
    }

    @NSManaged public var keyBody: String?
    @NSManaged public var contact: Contact?
    @NSManaged public var encryptedSender: Encrypted?
    @NSManaged public var id: Identity?
    @NSManaged public var messageSender: Message?

}

extension PublicKey : Identifiable {

}
