//
//  Contact.swift
//  StorageV1
//
//  Created by Ray Chen on 11/23/21.
//

import Foundation
import UIKit


class Contacts: ObservableObject {
    static let sharedInstance = Contacts()
    
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
	
	func addMessage(contactId: UUID, message: Message2, newMessage: Bool) {
        contacts[contactId]!.messages[message.id] = message
        if contacts[contactId]!.timeLatest < message.timeCreated {
            contacts[contactId]!.timeLatest =  message.timeCreated
        }
        if newMessage {
			contacts[contactId]!.newMessage = true
			let content = UNMutableNotificationContent()
			content.title = "New Message"
			content.body = "from " + contacts[contactId]!.nickname
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
			let request = UNNotificationRequest(identifier: message.id.uuidString, content: content, trigger: trigger)

			// Schedule the request with the system.
			let notificationCenter = UNUserNotificationCenter.current()
			notificationCenter.add(request)
		}
	}
	
	//	create message
	func createMessage(messageBody: String, sentByMe: Bool, contactId: UUID, messageType: Int = 0) {
		if contactId != Identity2.globalId || Identity2.fetchIdentity().globalChatroom {
			let newMessage = Message2(messageBody: messageBody, messageType: messageType,sentByMe: sentByMe, contactId: contactId, senderNickname: Identity2.fetchIdentity().nickname)
			self.addMessage(contactId: contactId, message: newMessage, newMessage: false)
			newMessage.encryptAndQueue(contactId: contactId)
		}
	}
	
	//	create message
	func createImageMessage(messageBody: UIImage, sentByMe: Bool, contactId: UUID) {
        self.createMessage(messageBody: messageBody.pngData()!.base64EncodedString(), sentByMe: sentByMe, contactId: contactId, messageType: 1)
	}
	
	func sawNewMessage(contactId: UUID) {
        contacts[contactId]!.newMessage = false
	}
	
	func fetchMessages(id: UUID) -> [Message2] {
		return contacts[id]!.fetchMessages()
	}
	
	func deleteContact(id: UUID) {
		contacts[id] = nil
	}
	
	func deleteMessage(id: UUID, contactId: UUID) {
		contacts[contactId]!.messages[id] = nil
	}
	
	

}
