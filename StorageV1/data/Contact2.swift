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
    
//    static var contacts: [Contact2]?
    public var id: UUID
    public var nickname: String
    public var timeLatest: Date
    public var messages: [UUID: Message2]
    public var publicKey: Data
    
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
//		if Contact2.contacts == nil{
//            Contact2.contacts = Array<Contact2>()
//        }
//        Contact2.contacts!.append(self)
	}
}



extension Contact2 {

    //  fetch the list of all messages
    func fetchMessages() -> [Message2] {
        return self.messages.values.sorted()
    }
    
    //	create message
	mutating func createMessage(messageBody: String, sentByMe: Bool) {
		let newMessage = Message2(messageBody: messageBody, sentByMe: sentByMe)
		self.messages[newMessage.id] = newMessage
		self.updateLatest(timeCreated: newMessage.timeCreated)
		self.encryptAndQueue(message: newMessage)
	}
	
	//	encrypted the message and add to the queue
	func encryptAndQueue(message: Message2) {
        let identity = Identity2.fetchIdentity()
		let newEncrypted = Encrypted2(id: message.id, messageType: message.messageType, timeCreated: message.timeCreated, receiverId: self.id, senderId: identity.id, senderNickname: identity.nickname, senderKey: identity.publicKey.base64EncodedString(), encryptedBody: encryptToData(publicKey: dataToPublicKey(keyBody: self.publicKey), msBody: message.messageBody))
		let encrypteds = Encrypteds()
		encrypteds.addEncrypted(encrypted: newEncrypted)
        BTController2.shared.createPayload()
    }
    
    //	update the latest messaging time
    mutating func updateLatest(timeCreated: Date){
        if self.timeLatest < timeCreated {
            self.timeLatest = timeCreated
        }
    }

    
    // fetch the list of all contacts, opt = 0 for sort based on timeLatest
//    static func fetchContacts(opt: Bool = true) -> [Contact2] {
//        if Contact2.contacts == nil{
//            Contact2.contacts = Array<Contact2>()
//        }
//        return Contact2.contacts!.sorted()
//    }
    
    // search Contact based on uuid
//    static func fetchContacts(id: UUID) -> Contact2? {
//        let c = contacts!
//        for i in c{
//            if i.id == id{
//                return i
//            }
//        }
//        return Contact2()
//    }
    
    
    
    //    retrive the latest message of all contacts
//    func fetchLatests() -> [Message2] {
//        let contacts = Contact2.fetchContacts(opt: false)
//        var data = [Message2]()
//        for ct in contacts {
//                data.append(ct.fetchMessages()[-1])
//        }
//        return data
//    }
    
    //    add new message to contact list
//    mutating func createChatMessage(body: String,identity: Identity2) {
//        var newMessage = Message2(messageType: 0, sentByMe: true)
//        newMessage.timeCreated = Date()
//        newMessage.messageBody = body
//        newMessage.contact = self
//        newMessage.sentByMe = true
//        newMessage.encryptAndQueue(identity: identity)
//        self.timeLatest = newMessage.timeCreated!
//        if self.messages == nil{
//            self.messages = Array<Message2>()
//        }
//        self.messages.append(newMessage)
//    }
//
//
//
//    static func addEncrypted(encryptedBody: Data?, messageType: Int16, receiverId: UUID, senderId: UUID, timeCreated: Date, senderNickname: String?, senderKey: String?) -> Encrypted2{
//        var newEncrypted = Encrypted2(messageType: messageType)
//        newEncrypted.receiverId = receiverId
//        newEncrypted.senderId = senderId
//        newEncrypted.messageType = messageType
//        newEncrypted.timeCreated = timeCreated
//        let pubKey = KeyUtils.stringToKeyBody(key: senderKey!)
//
//        newEncrypted.senderKey = pubKey.base64EncodedString()
//        newEncrypted.senderNickname = senderNickname
//        newEncrypted.encryptedBody = encryptedBody
//        if Encrypted2.encrypteds == nil{
//            Encrypted2.encrypteds = Array<Encrypted2>()
//        }
//        Encrypted2.encrypteds!.append(newEncrypted)
//        return newEncrypted
//    }
//
//    //    create contact (called in checkAndSearch() and TODO: QRContact())
//    static func createContact(nn: String, key: Data, id: UUID) -> Contact2 {
//
//        var newContact = Contact2()
//        newContact.nickname = nn
//        newContact.id = id
//        newContact.publicKey = key
////		let identity = Identity2.fetchIdentity()
////        newContact.identity = identity
//        newContact.timeLatest = Date()
//        newContact.initlist()
//        if Contact2.contacts == nil{
//            Contact2.contacts = Array<Contact2>()
//        }
//        Contact2.contacts!.append(newContact)
//        _ = Contact2.contacts
//        return newContact
//    }
//
//
//    //    create contact (called when QR scanned)
//    static func createContact(nn: String, keybody: String, id: String) -> Contact2 {
//        return searchOrCreate(nn: nn, key: KeyUtils.stringToKeyBody(key: keybody), id: UUID(uuidString: id)!)
//    }
//
//    // search contact with id, if not exist, create with nn, id, key
//    static func searchOrCreate(nn: String, id: UUID) -> Contact2 {
//        let c = Contact2.fetchContacts()
//        for i in c{
//            if i.id!.uuidString == id.uuidString{return i}
//        }
//        return Contact2()
//    }
//
//
//    static func searchOrCreate(nn: String, key: Data, id: UUID) -> Contact2 {
//        let c = Contact2.fetchContacts()
//        for i in c{
//            if i.id!.uuidString == id.uuidString{return i}
//        }
//        return createContact(nn: nn, key: key, id: id)
//    }
//
//
//    //fetch the latest message body
//    func fetchLatestMessageString() -> String {
//        if self.messages == nil || self.messages.isEmpty{
//            return ""
//        }
//        return self.fetchMessages()[-1].messageBody!
//    }
//
//    //    delete
//    func delete() {
//        //TODO
//    }

}


