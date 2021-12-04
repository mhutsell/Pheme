//
//  Contact2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation

struct Contact2: Identifiable, Hashable, Codable, Comparable{
    
    
    static func < (lhs: Contact2, rhs: Contact2) -> Bool {
        return lhs.timeLatest > rhs.timeLatest
    }
    
    static func == (lhs: Contact2, rhs: Contact2) -> Bool {
        return lhs.id == rhs.id
    }
    
	
	public var id: UUID
    public var nickname: String
    public var timeLatest: Date
    public var messages: [UUID: Message2]
    public var publicKey: Data
    public var newMessage: Bool
    
    public init (
		id: UUID = UUID(),
		nickname: String? = nil,
		timeLatest: Date = Date(),
		publicKey: Data? = nil
    ) {
		self.id = id
		self.nickname = nickname!
		self.publicKey = publicKey!
		self.timeLatest = timeLatest
		self.messages = [:]
		self.newMessage = false
	}
}



extension Contact2 {

    //  fetch the list of all messages
    func fetchMessages() -> [Message2] {
        return self.messages.values.sorted()
    }
	
	func LatestMessageString() -> String {
		let messages = self.fetchMessages()
		if messages.count == 0 {
			if self.id == Identity2.globalId {
					return "Welcome to the global chatroom!"
				}
			return "We are friends now!"
		} else {
			if messages[messages.count-1].messageType == 0 {
				return messages[messages.count-1].messageBody
			} else {
				return "[Image]"
			}
		}
	}
	

}


