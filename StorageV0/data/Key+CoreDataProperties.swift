//
//  Key+CoreDataProperties.swift
//  StorageV0
//
//  Created by Ray Chen on 9/29/21.
//
//

import Foundation
import CoreData


extension Key {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Key> {
        return NSFetchRequest<Key>(entityName: "Key")
    }

    @NSManaged public var keyTypeAgreement: String?
    @NSManaged public var keyBody: Bytes?
    @NSManaged public var keyPermanentPrivate: Identity?
    @NSManaged public var keyPermanentPublic: Identity?

}

extension Key : Identifiable {

}
