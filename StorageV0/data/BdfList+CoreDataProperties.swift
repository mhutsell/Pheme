//
//  BdfList+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 9/29/21.
//
//

import Foundation
import CoreData


extension BdfList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BdfList> {
        return NSFetchRequest<BdfList>(entityName: "BdfList")
    }

    @NSManaged public var bdfEntry: NSSet?

}

// MARK: Generated accessors for bdfEntry
extension BdfList {

    @objc(addBdfEntryObject:)
    @NSManaged public func addToBdfEntry(_ value: Bdf)

    @objc(removeBdfEntryObject:)
    @NSManaged public func removeFromBdfEntry(_ value: Bdf)

    @objc(addBdfEntry:)
    @NSManaged public func addToBdfEntry(_ values: NSSet)

    @objc(removeBdfEntry:)
    @NSManaged public func removeFromBdfEntry(_ values: NSSet)

}

extension BdfList : Identifiable {

}
