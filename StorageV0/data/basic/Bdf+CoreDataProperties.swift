//
//  Bdf+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 9/29/21.
//
//

import Foundation
import CoreData


extension Bdf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bdf> {
        return NSFetchRequest<Bdf>(entityName: "Bdf")
    }

    @NSManaged public var bdfKey: String?
    @NSManaged public var value: NSObject?
    @NSManaged public var listBdf: BdfList?

}

extension Bdf : Identifiable {

}
