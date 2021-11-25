//
//  Message2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation
struct Message2: Identifiable, Hashable, Codable, Comparable{
	
	public var id: UUID
	
    static func < (lhs: Message2, rhs: Message2) -> Bool {
        return lhs.timeCreated < rhs.timeCreated
    }
    
    static func == (lhs: Message2, rhs: Message2) -> Bool {
        return lhs.timeCreated == rhs.timeCreated
    }
    
     public var messageBody: String
     public var messageType: Int16
     public var timeCreated: Date
     public var sentByMe: Bool
     public var contactId: UUID
     
     public init (
		id: UUID = UUID(),
		messageBody: String? = nil,
		messageType: Int16 = 0,
		timeCreated: Date = Date(),
		sentByMe: Bool? = nil,
        contactId: UUID
     ) {
		self.id = id
		self.messageBody = messageBody!
		self.messageType = messageType
        self.timeCreated = timeCreated
		self.sentByMe = sentByMe!
        self.contactId = contactId
	 }
	 
	 public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(timeCreated)
    }
    
}
