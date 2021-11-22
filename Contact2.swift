//
//  Contact2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation

struct Contact2: Comparable{
    static func < (lhs: Contact2, rhs: Contact2) -> Bool {
        return lhs.timeLatest! < rhs.timeLatest!
    }
    
    static func == (lhs: Contact2, rhs: Contact2) -> Bool {
        return lhs.id == rhs.id
    }
    static var contacts: [Contact2]?
    public var id: UUID?
    public var nickname: String?
    public var timeLatest: Date?
    public var identity: Identity2?
    public var messages: [Message2]!
    public var theirKey: PublicKey2?
    
    
}



extension Contact2 {

    //    fetch the list of all messages of all
    func fetchMessages() -> [Message2] {
        if self.messages == nil{
            return Array<Message2>()
        }
        else{
            return self.messages!.sorted()
        }
    }
    mutating func initlist() {
        if self.messages == nil{
            self.messages = Array<Message2>()
        }
    }
    
    // fetch the list of all contacts, opt = 0 for sort based on timeLatest
    static func fetchContacts(opt: Bool = true) -> [Contact2] {
        if Contact2.contacts == nil{
            Contact2.contacts = Array<Contact2>()
        }
        return Contact2.contacts!.sorted()
    }
    
    // search Contact based on uuid
    static func fetchContacts(id: UUID) -> Contact2? {
        var c = contacts!
        for i in c{
            if i.id == id{
                return i
            }
        }
        return Contact2()
    }
    
    mutating func updateLatest(timeCreated: Date?){
        if self.timeLatest! < timeCreated!{
            self.timeLatest = timeCreated
        }
    }
    
    //    retrive the latest message of all contacts
    func fetchLatests() -> [Message2] {
        let contacts = Contact2.fetchContacts(opt: false)
        var data = [Message2]()
        for ct in contacts {
                data.append(ct.fetchMessages()[-1])
        }
        return data
    }
    
    //    add new message to contact list
    mutating func createChatMessage(body: String) {
        var newMessage = Message2(messageType: 0, sentByMe: true)
        newMessage.timeCreated = Date()
        newMessage.messageBody = body
        newMessage.contact = self
        newMessage.sentByMe = true
        newMessage.encryptAndQueue()
        self.timeLatest = newMessage.timeCreated
        if self.messages == nil{
            self.messages = Array<Message2>()
        }
        self.messages?.append(newMessage)
    }
    
    //    create message
    mutating func createMessage(body: String) {
        var newMessage = Message2(messageType: 0, sentByMe: true)
        newMessage.timeCreated = Date()
        newMessage.messageBody = body
        newMessage.contact = self
        newMessage.sentByMe = true
        newMessage.encryptAndQueue()
        if self.messages == nil{
            self.messages = Array<Message2>()
        }
        self.messages?.append(newMessage)
        self.timeLatest = newMessage.timeCreated
    }
    

    
    static func addEncrypted(encryptedBody: Data?, messageType: Int16, receiverId: UUID, senderId: UUID, timeCreated: Date, senderNickname: String?, senderKey: String?) -> Encrypted2{
        var newEncrypted = Encrypted2(messageType: messageType)
        newEncrypted.receiverId = receiverId
        newEncrypted.senderId = senderId
        newEncrypted.messageType = messageType
        newEncrypted.timeCreated = timeCreated
        var pubKey = PublicKey2.createPublicKey(key: senderKey!)
       
        newEncrypted.senderKey = pubKey.keyBody!.base64EncodedString()
        newEncrypted.senderNickname = senderNickname
        newEncrypted.encryptedBody = encryptedBody
        if Encrypted2.encrypteds == nil{
            Encrypted2.encrypteds = Array<Encrypted2>()
        }
        Encrypted2.encrypteds!.append(newEncrypted)
        return newEncrypted
    }
    
    //    create contact (called in checkAndSearch() and TODO: QRContact())
    static func createContact(nn: String, key: PublicKey2, id: UUID) -> Contact2 {
        
        var newContact = Contact2()
        newContact.nickname = nn
        newContact.id = id
        newContact.theirKey = key
        var identity = Identity2.fetchIdentity()
        newContact.identity = identity
        newContact.timeLatest = Date()
        newContact.initlist()
        if Contact2.contacts == nil{
            Contact2.contacts = Array<Contact2>()
        }
        Contact2.contacts!.append(newContact)
        var l = Contact2.contacts
        return newContact
    }
    
   
    //    create contact (called when QR scanned)
    static func createContact(nn: String, keybody: String, id: String) -> Contact2 {
        return searchOrCreate(nn: nn, key: PublicKey2.createPublicKey(key: keybody), id: UUID(uuidString: id)!)
    }
    
    // search contact with id, if not exist, create with nn, id, key
    static func searchOrCreate(nn: String, id: UUID) -> Contact2 {
        var c = Contact2.fetchContacts()
        for i in c{
            if i.id!.uuidString == id.uuidString{return i}
        }
        return Contact2()
    }
    
    
    static func searchOrCreate(nn: String, key: PublicKey2, id: UUID) -> Contact2 {
        var c = Contact2.fetchContacts()
        for i in c{
            if i.id!.uuidString == id.uuidString{return i}
        }
        return createContact(nn: nn, key: key, id: id)
    }
    
    
    //fetch the latest message body
    func fetchLatestMessageString() -> String {
        if self.messages == nil || self.messages.isEmpty{
            return ""
        }
        return self.fetchMessages()[-1].messageBody!
    }
    
    //    delete
    func delete() {
        //TODO
    }

}


