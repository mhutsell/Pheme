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
    
	
	static public var all:  [UUID: Contact2] = Contacts.sharedInstance.contacts
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
	static func createMessage(messageBody: String, sentByMe: Bool, contactId: UUID) {
        let newMessage = Message2(messageBody: messageBody, sentByMe: sentByMe, contactId: contactId)
//        Message2.all.append(newMessage)
//        Messages.sharedInstance.messages[newMessage.id] = newMessage
//        var testml = Messages().messages
//        var contactsCopy = Contact2.all
//        contactsCopy[contactId]!.messages[newMessage.id] = newMessage
//        Contact2.all = contactsCopy
//		Contact2.all[contactId]!.messages[newMessage.id] = newMessage
		Contact2.updateLatest(timeCreated: newMessage.timeCreated, contactId: contactId)
		Contact2.encryptAndQueue(message: newMessage, contactId: contactId)
		Contacts.sharedInstance.createMessage(contactId: contactId, message: newMessage)
	}
	
	//	encrypted the message and add to the queue
	static func encryptAndQueue(message: Message2, contactId: UUID) {
        let identity = Identity2.fetchIdentity()
		_ = Encrypted2(id: message.id, messageType: message.messageType, timeCreated: message.timeCreated, receiverId: contactId, senderId: identity.id, senderNickname: identity.nickname, senderKey: identity.publicKey.base64EncodedString(), encryptedBody: encryptToData(publicKey: dataToPublicKey(keyBody: Contact2.all[contactId]!.publicKey), msBody: message.messageBody), add: true)
        BTController2.shared.createPayload()
    }
    
    //	update the latest messaging time
    static func updateLatest(timeCreated: Date, contactId: UUID){
        if Contact2.all[contactId]!.timeLatest < timeCreated {
            Contact2.all[contactId]!.timeLatest = timeCreated
            Contacts.sharedInstance.contacts[contactId]!.timeLatest = timeCreated
        }
    }

    static func searchOrCreate(nn: String, id: String, keyString: String) {
		Contact2.searchOrCreate(nn: nn, id: UUID(uuidString: id)!, keyBody: stringToKeyBody(key: keyString))
	}
	
	static func searchOrCreate(nn: String, id: UUID, keyBody: Data) {
//		if Contact2.all == nil || Contact2.all![id] == nil {
//			Contact2.creatContact(nn: nn, id: id, keyBody: keyBody)
//		}
//        let contacts = Contacts.sharedInstance
        if Contact2.all[id] == nil {
            Contact2.creatContact(nn: nn, id: id, keyBody: keyBody)
        }
	}
	
	static func creatContact(nn: String, id: UUID, keyBody: Data) {
		Contacts.sharedInstance.contacts[id] = Contact2(id: id, nickname: nn, publicKey: keyBody)
	}
	
	static func addDecrypted(message: Message2, contactId: UUID) {
		Contact2.all[contactId]!.messages[message.id] = message
        Contact2.updateLatest(timeCreated: message.timeCreated, contactId: contactId)
        Contact2.all[contactId]!.newMessage = true
        Contacts.sharedInstance.addDecrypted(contactId: contactId, message: message)
	}
	
	static func sawNewMessage(contactId: UUID) {
		Contact2.all[contactId]!.newMessage = false
        Contacts.sharedInstance.sawNewMessage(contactId: contactId)
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
		Contacts.sharedInstance.deleteContact(id: id)
	}
	
	static func deleteMessage(id: UUID, contactId: UUID) {
		Contact2.all[contactId]!.messages[id] = nil
		Contacts.sharedInstance.deleteMessage(id: id, contactId: contactId)
	}

}


