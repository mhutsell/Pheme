//
//  EncryptedMessage+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ken Su on 10/6/21.
//
//

import Foundation
import CoreData


extension EncryptedMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EncryptedMessage> {
        return NSFetchRequest<EncryptedMessage>(entityName: "EncryptedMessage")
    }

    @NSManaged public var encryptedBody: String?
    @NSManaged public var senderID: Int64
    @NSManaged public var middleCarrier: Identity?

}

extension EncryptedMessage : Identifiable {

}
