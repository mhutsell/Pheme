//
//  PrivateKey+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/16/21.
//
//

import Foundation
import CoreData


extension PrivateKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrivateKey> {
        return NSFetchRequest<PrivateKey>(entityName: "PrivateKey")
    }

    @NSManaged public var keyBody: Data?
    @NSManaged public var identity: Identity?

}

extension PrivateKey : Identifiable {

}
