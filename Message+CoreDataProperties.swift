//
//  Message+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 10/6/21.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var messageBody: String?
    @NSManaged public var messageType: String?
    @NSManaged public var senderID: Int64
    @NSManaged public var timeCreated: Date?
    @NSManaged public var belongToContact: Contact?
    @NSManaged public var publicKey: Key?

}

extension Message : Identifiable {

}
