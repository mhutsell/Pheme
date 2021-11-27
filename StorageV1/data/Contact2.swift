//
//  Contact2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation

struct Contact2: Identifiable, Hashable, Codable, Comparable{
    
    
    static func < (lhs: Contact2, rhs: Contact2) -> Bool {
        return lhs.timeLatest < rhs.timeLatest
    }
    
    static func == (lhs: Contact2, rhs: Contact2) -> Bool {
        return lhs.id == rhs.id
    }
    
	static public var all:  [UUID: Contact2] = Contacts().contacts
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
		Contact2.all[id] = self
	}
}



extension Contact2 {

    //  fetch the list of all messages
    func fetchMessages() -> [Message2] {
        return self.messages.values.sorted()
    }
    
    //	create message
	mutating func createMessage(messageBody: String, sentByMe: Bool) {
        let newMessage = Message2(messageBody: messageBody, sentByMe: sentByMe, contactId: self.id)
		self.messages[newMessage.id] = newMessage
		self.updateLatest(timeCreated: newMessage.timeCreated)
		Contact2.all[self.id]! = self
		self.encryptAndQueue(message: newMessage)
		Contacts().createMessage(contactId: self.id, message: newMessage)
	}
	
	//	encrypted the message and add to the queue
	func encryptAndQueue(message: Message2) {
        let identity = Identity2.fetchIdentity()
		_ = Encrypted2(id: message.id, messageType: message.messageType, timeCreated: message.timeCreated, receiverId: self.id, senderId: identity.id, senderNickname: identity.nickname, senderKey: identity.publicKey.base64EncodedString(), encryptedBody: encryptToData(publicKey: dataToPublicKey(keyBody: self.publicKey), msBody: message.messageBody), add: true)
        BTController2.shared.createPayload()
    }
    
    //	update the latest messaging time
    mutating func updateLatest(timeCreated: Date){
        if self.timeLatest < timeCreated {
            self.timeLatest = timeCreated
            Contacts().contacts[self.id]!.timeLatest = timeCreated
        }
    }

    static func searchOrCreate(nn: String, id: String, keyString: String) {
		Contact2.searchOrCreate(nn: nn, id: UUID(uuidString: id)!, keyBody: stringToKeyBody(key: keyString))
	}
	
	static func searchOrCreate(nn: String, id: UUID, keyBody: Data) {
//		if Contact2.all == nil || Contact2.all![id] == nil {
//			Contact2.creatContact(nn: nn, id: id, keyBody: keyBody)
//		}
//        let contacts = Contacts()
        if Contact2.all[id] == nil {
            Contact2.creatContact(nn: nn, id: id, keyBody: keyBody)
        }
	}
	
	static func creatContact(nn: String, id: UUID, keyBody: Data) {
		Contacts().contacts[id] = Contact2(id: id, nickname: nn, publicKey: keyBody)
	}
	
	mutating func addDecrypted(message: Message2) {
		self.messages[message.id] = message
        self.updateLatest(timeCreated: message.timeCreated)
        self.newMessage = true
        Contacts().addDecrypted(contactId: self.id, message: message)
	}
	
	static func sawNewMessage(contactId: UUID) {
		Contact2.all[contactId]!.newMessage = false
        Contacts().sawNewMessage(contactId: contactId)
	}
	
	
	func LatestMessageString() -> String {
		let messages = self.fetchMessages()
		if messages.count == 0 {
			return "We are friends now."
		} else {
			return messages[messages.count-1].messageBody
		}
	}
	
    
	static func deleteContact(id: UUID) {
		Contact2.all[id] = nil
		Contacts().deleteContact(id: id)
	}
	
	static func deleteMessage(id: UUID, contactId: UUID) {
		Contact2.all[contactId]!.messages[id] = nil
		Contacts().deleteMessage(id: id, contactId: contactId)
	}

}


