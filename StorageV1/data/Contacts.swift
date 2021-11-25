//
//  Contact.swift
//  StorageV1
//
//  Created by Ray Chen on 11/23/21.
//

import Foundation


class Contacts: ObservableObject {
    @Published(persistingTo: "Contact/contact_messages.json") var contacts: [UUID: Contact2] = [:]

	init() {}
	
	init(contacts: [Contact2]) {
        self.contacts = Dictionary(contacts.map { ($0.id, $0) }, uniquingKeysWith: { k, _ in k })
    }
    
    subscript(id: UUID) -> Contact2? {
        contacts[id]
    }
    
    func searchOrCreate(nn: String, id: String, keyString: String) {
		searchOrCreate(nn: nn, id: UUID(uuidString: id)!, keyBody: stringToKeyBody(key: keyString))
	}
	
	func searchOrCreate(nn: String, id: UUID, keyBody: Data) {
		if contacts[id] == nil {
			creatContact(nn: nn, id: id, keyBody: keyBody)
		}
	}
	
	func creatContact(nn: String, id: UUID, keyBody: Data) {
		contacts[id] = Contact2(id: id, nickname: nn, publicKey: keyBody)
        
	}
	
	func createMessage(body: String, contactId: UUID) {
        contacts[contactId]!.createMessage(messageBody: body, sentByMe: true)
	}
	
	//	TODO: push notification?
	func addDecrypted(message: Message2, contactId: UUID) {
        contacts[contactId]!.messages[message.id] = message
        contacts[contactId]!.updateLatest(timeCreated: message.timeCreated)
        contacts[contactId]!.newMessage = true
	}
	
	func sawNewMessage(contactId: UUID) {
        contacts[contactId]!.newMessage = false
	}
	
	func fetchMessages(id: UUID) -> [Message2] {
		return contacts[id]!.fetchMessages()
	}
	
	func LatestMessageString(id: UUID) -> String {
		let messages = self.fetchMessages(id: id)
		if messages.count == 0 {
			return "We are friends now."
		} else {
			return messages[messages.count-1].messageBody
		}
	}
	
	func deleteContact(id: UUID) {
		contacts[id] = nil
	}
	
	func deleteMessage(id: UUID, contactID: UUID) {
		contacts[id]!.messages[id] = nil
	}
	
	

}
