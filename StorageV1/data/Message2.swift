//
//  Message2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation
import UIKit
import UserNotifications

struct Message2: Identifiable, Hashable, Codable, Comparable{
	
	public var id: UUID
	
    static func < (lhs: Message2, rhs: Message2) -> Bool {
        return lhs.timeCreated < rhs.timeCreated
    }
    
    static func == (lhs: Message2, rhs: Message2) -> Bool {
        return lhs.timeCreated == rhs.timeCreated
    }
    
    static public var all: [Message2] = Array(Messages().messages.values)
	public var messageBody: String
	public var messageType: Int
//	messageType: 0 pure text, 1 image
//	TODO: 2 text with emoji (no need?)
	public var timeCreated: Date
	public var sentByMe: Bool
	public var contactId: UUID
	public var senderNickname: String
     
	public init (
		id: UUID = UUID(),
		messageBody: String? = nil,
		messageType: Int = 0,
		timeCreated: Date = Date(),
		sentByMe: Bool? = nil,
        contactId: UUID,
        senderNickname: String? = nil
	) {
		self.id = id
		self.messageBody = messageBody!
		self.messageType = messageType
        self.timeCreated = timeCreated
		self.sentByMe = sentByMe!
        self.contactId = contactId
        self.senderNickname = senderNickname!
        Message2.all.append(self)
        Messages().messages[id] = self
	}
	 
	public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(timeCreated)
	}
    
		//	encrypted the message and add to the queue
	func encryptAndQueue(contactId: UUID) {
		let identity = Identity2.fetchIdentity()
		_ = Encrypted2(id: self.id, messageType: self.messageType, timeCreated: self.timeCreated, receiverId: contactId, senderId: identity.id, senderNickname: identity.nickname, senderKey: identity.publicKey.base64EncodedString(), encryptedBody: encryptToData(publicKey: dataToPublicKey(keyBody: Contacts.sharedInstance.contacts[contactId]!.publicKey), msBody: self.messageBody), add: true)
		BTController2.shared.createPayload()
	}
    
    func displayImageMessage() -> UIImage {
		return UIImage(data: Data(base64Encoded: self.messageBody, options: .ignoreUnknownCharacters)!)!
	}
    
    
}
