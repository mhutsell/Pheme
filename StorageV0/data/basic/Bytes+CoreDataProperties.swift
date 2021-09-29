//
//  Bytes+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 9/29/21.
//
//

import Foundation
import CoreData


extension Bytes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bytes> {
        return NSFetchRequest<Bytes>(entityName: "Bytes")
    }

    @NSManaged public var bytes: Data?
    @NSManaged public var hashCode: Int16
    @NSManaged public var keyBytes: Key?

}

extension Bytes : Identifiable {

}
