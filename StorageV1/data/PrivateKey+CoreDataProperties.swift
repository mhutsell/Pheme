//
//  PrivateKey+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//
//

import Foundation
import CoreData


extension PrivateKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrivateKey> {
        return NSFetchRequest<PrivateKey>(entityName: "PrivateKey")
    }

    @NSManaged public var keyBody: String?
    @NSManaged public var id: Identity?

}

extension PrivateKey : Identifiable {

}
