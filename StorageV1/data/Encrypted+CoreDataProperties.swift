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

extension Encrypted : Identifiable {

}
