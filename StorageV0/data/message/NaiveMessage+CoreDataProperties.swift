//
//  NaiveMessage+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 9/29/21.
//
//

import Foundation
import CoreData


extension NaiveMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NaiveMessage> {
        return NSFetchRequest<NaiveMessage>(entityName: "NaiveMessage")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var messageBody: String?
    @NSManaged public var timeCreated: Date?
    @NSManaged public var belongsTo: Identity?

}

extension NaiveMessage : Identifiable {

}
