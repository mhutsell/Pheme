//
//  Encrypted2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation

struct Encrypted2: Identifiable, Hashable, Codable, Comparable{

    static func < (lhs: Encrypted2, rhs: Encrypted2) -> Bool {
		return lhs.timeCreated < rhs.timeCreated
    }
    
    static func == (lhs: Encrypted2, rhs: Encrypted2) -> Bool {
        return lhs.timeCreated == rhs.timeCreated
    }
    
    public var id: UUID
    public var encryptedBody: Data
    public var messageType: Int
    public var receiverId: UUID
    public var senderId: UUID
    public var timeCreated: Date
    public var senderNickname: String
    public var senderKey: String
    
    public init (
		id: UUID = UUID(),
		messageType: Int = 0,
		timeCreated: Date = Date(),
		receiverId: UUID? = nil,
		senderId: UUID? = nil,
		senderNickname: String? = nil,
		senderKey: String? = nil,
		encryptedBody: Data? = nil,
		add: Bool = false
     ) {
		self.id = id
		self.messageType = messageType
		self.timeCreated = timeCreated
		self.receiverId = receiverId!
		self.senderId = senderId!
		self.senderNickname = senderNickname!
		self.senderKey = senderKey!
		self.encryptedBody = encryptedBody!
		if add {
			Encrypteds.sharedInstance.addEncrypted(encrypted: self)
		}
	 }
	 
	 public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(timeCreated)
    }

    func to_json() -> String{
		var to_return = "{{{{{" + self.encryptedBody.base64EncodedString()
        to_return += "|||||\(self.messageType)"
		to_return += "|||||\(self.receiverId)"
        to_return += "|||||\(self.senderId)"
        to_return += "|||||\(self.timeCreated)"
        to_return += "|||||\(self.senderNickname)"
        to_return += "|||||\(self.id)"
        to_return += "|||||" + self.senderKey + "|||||}}}}}"
        return to_return
    }

    static func from_json(incomingMessage: String){
		var str_msgs = "\(incomingMessage)"
		if (incomingMessage == ""){
            return
        }
		str_msgs.remove(at: str_msgs.startIndex)
		str_msgs.remove(at: str_msgs.index(str_msgs.endIndex, offsetBy: -1))
		let split_msgs:[String] = str_msgs.components(separatedBy: "{{{{{")
		let date_formatter = DateFormatter()
		date_formatter.locale = Locale(identifier: "en_US_POSIX")
		date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
		firstFor: for json_msg in split_msgs{
			if (json_msg == ""){
				continue
			}
			let split_comps:[String] = json_msg.components(separatedBy: "|||||")
			if(split_comps.count < 8){
                 continue
             }
			let encryptedBody: Data? = Data(base64Encoded: split_comps[0], options: .ignoreUnknownCharacters)
			let messageType: Int? = Int(split_comps[1])
			let receiverId: UUID? = UUID(uuidString: split_comps[2])
			let senderId: UUID? = UUID(uuidString: split_comps[3])
			let timeCreated: Date? = date_formatter.date(from: split_comps[4])
			let senderNickname: String? = split_comps[5]
			let id:  UUID? = UUID(uuidString: split_comps[6])
			var senderKey: String? = split_comps[7]
			senderKey = senderKey!.padding(toLength: ((senderKey!.count+3)/4)*4,
										  withPad: "=",
										  startingAt: 0)
			if Encrypted2.hasId(id: id!, receiverId: receiverId!, senderId: senderId!) {
				continue
			}
			let newEncrypted = Encrypted2(id: id!, messageType: messageType!, timeCreated: timeCreated!, receiverId: receiverId!, senderId: senderId!, senderNickname: senderNickname!, senderKey: senderKey!, encryptedBody: encryptedBody!)
			
			newEncrypted.checkAndSearch()
		}
		BTController2.shared.createPayload()
    }
    
    static func hasId(id: UUID, receiverId: UUID, senderId: UUID) -> Bool {
		if receiverId == Identity2.fetchIdentity().id {
			return Contacts.sharedInstance.contacts[senderId] != nil && Contacts.sharedInstance.contacts[senderId]!.messages[id] != nil
		} else if receiverId == Identity2.globalId {
			return !Identity2.fetchIdentity().globalChatroom || Contacts.sharedInstance.contacts[receiverId]!.messages[id] != nil
		} else if senderId == Identity2.fetchIdentity().id {
			return true
		} else {
			return Encrypteds.sharedInstance.encrypteds[id] != nil
		}
	}

    
    //    search if this encrypted is for me and search the contact who send this message
    //    if no existing contact exists, create contact
    func checkAndSearch() {
        if self.receiverId == Identity2.globalId {
			Encrypteds.sharedInstance.addEncrypted(encrypted: self)
			self.decryptTo(contactId: self.receiverId)
		} else if (self.receiverId == Identity2.fetchIdentity().id) {
            Contacts.sharedInstance.searchOrCreate(nn: self.senderNickname, id: self.senderId, keyBody: stringToKeyBody(key: self.senderKey))
			self.decryptTo(contactId: self.senderId)
        } else if (Identity2.fetchIdentity().helpOthers) {
            Encrypteds.sharedInstance.addEncrypted(encrypted: self)
        }
    }
    
    //    decrypt the encrypt with my key
    func decryptTo(contactId: UUID) {
        if (contactId != Identity2.globalId) {
			let newMessage = Message2(id: self.id, messageBody: decryptToString(privateKey: dataToPrivateKey(keyBody: Identity2.fetchIdentity().privateKey), body: self.encryptedBody), messageType: self.messageType, timeCreated: self.timeCreated, sentByMe: false, contactId: contactId, senderNickname: self.senderNickname)
			Contacts.sharedInstance.addMessage(contactId: contactId, message: newMessage, newMessage: true)
		} else {
			let newMessage = Message2(id: self.id, messageBody: decryptToString(privateKey: dataToPrivateKey(keyBody: Identity2.globalPrivateKey), body: self.encryptedBody), messageType: self.messageType, timeCreated: self.timeCreated, sentByMe: false, contactId: contactId, senderNickname: self.senderNickname)
			Contacts.sharedInstance.addMessage(contactId: contactId, message: newMessage, newMessage: true)
		}
    }
    
}


