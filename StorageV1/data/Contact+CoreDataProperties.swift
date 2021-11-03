//
//  Contact+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/31/21.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var nickname: String?
    @NSManaged public var timeLatest: Date?
    @NSManaged public var identity: Identity?
    @NSManaged public var messages: NSSet?
    @NSManaged public var theirKey: PublicKey?

}

extension Contact {

	//	fetch the list of all messages of all
	 func fetchMessages() -> [Message] {
		let fr: NSFetchRequest<Message> = Message.fetchRequest()
		fr.predicate = NSPredicate(
			format: "contact LIKE %@", self
		)
		fr.sortDescriptors = [NSSortDescriptor(keyPath: \Message.timeCreated, ascending:false)]
		do {
			let mss = try PersistenceController.shared.container.viewContext.fetch(fr)
			return mss
		} catch {let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}

}

// MARK: Generated accessors for messages
extension Contact {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

extension Contact : Identifiable {

}
