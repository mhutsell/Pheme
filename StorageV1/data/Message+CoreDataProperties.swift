//
//  Message+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/20/21.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var messageBody: String?
    @NSManaged public var messageType: Int16
    @NSManaged public var timeCreated: Date?
    @NSManaged public var contact: Contact?

}

extension Message : Identifiable {

}
