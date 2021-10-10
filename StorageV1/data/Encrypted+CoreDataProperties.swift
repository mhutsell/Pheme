//
//  Encrypted+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/10/21.
//
//

import Foundation
import CoreData


extension Encrypted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Encrypted> {
        return NSFetchRequest<Encrypted>(entityName: "Encrypted")
    }

    @NSManaged public var encryptedBody: String?
    @NSManaged public var timeCreated: Date?
    @NSManaged public var messageType: Int16
    @NSManaged public var id: Identity?
    @NSManaged public var senderKey: PublicKey?

}

extension Encrypted : Identifiable {

}
