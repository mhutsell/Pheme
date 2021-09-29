//
//  Identity+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 9/29/21.
//
//

import Foundation
import CoreData


extension Identity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identity> {
        return NSFetchRequest<Identity>(entityName: "Identity")
    }

    @NSManaged public var timeCreated: Date?
    @NSManaged public var permanentPrivateKey: Key?
    @NSManaged public var permanentPublicKey: Key?

}

extension Identity : Identifiable {

}
