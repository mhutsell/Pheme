//
//  Encrypted2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation

struct Encrypted2: Comparable{
    static func < (lhs: Encrypted2, rhs: Encrypted2) -> Bool {
        return lhs.timeCreated! < rhs.timeCreated!
    }
    
    
    
    static func == (lhs: Encrypted2, rhs: Encrypted2) -> Bool {
        return lhs.timeCreated == rhs.timeCreated
    }
    
    static var encrypteds: Array<Encrypted2>?
    public var encryptedBody: Data?
    public var messageType: Int16
    public var receiverId: UUID?
    public var senderId: UUID?
    public var timeCreated: Date?
    public var senderNickname: String?
    public var senderKey: String?

    func to_json() -> String{
        var to_return = "{{{{{" + self.encryptedBody!.base64EncodedString()
        to_return += "|||||\(self.messageType)"
        to_return += "|||||\(self.receiverId!)"
        to_return += "|||||\(self.senderId!)"
        to_return += "|||||\(self.timeCreated!)"
        to_return += "|||||\(self.senderNickname!)"
        var our_id = Identity.fetchIdentity()
        //to_return += "|||||\(self.senderKey!.keyBody)" + "|||||}}}}}"
        to_return += "|||||" + our_id.publicKey!.keyBody!.base64EncodedString() + "|||||}}}}}"
        return to_return
    }

    static func from_json(incomingMessage: String){
        if BTController2.hasReceived{
            return
        }

            BTController2.hasReceived = true
            var str_msgs = "\(incomingMessage)"
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
                let encryptedBody: Data? = Data(base64Encoded: split_comps[0], options: .ignoreUnknownCharacters)
                let messageType: Int16? = Int16(split_comps[1])
                let receiverId: UUID? = UUID(uuidString: split_comps[2])
                let senderId: UUID? = UUID(uuidString: split_comps[3])
                let timeCreated: Date? = date_formatter.date(from: split_comps[4])
                let senderNickname: String? = split_comps[5]
                var senderKey: String? = split_comps[6]
                senderKey = senderKey!.padding(toLength: ((senderKey!.count+3)/4)*4,
                                              withPad: "=",
                                              startingAt: 0)
                // Use encrypted not contact fetch messages - message might not be for us.
                let curr_s_contact = Contact2.searchOrCreate(nn: senderNickname!, key: PublicKey2.createPublicKey(key: senderKey!), id: senderId!)
                let curr_msgs: [Message2] = curr_s_contact.fetchMessages()
                for curr_msg in curr_msgs{
                    if (curr_msg.timeCreated == timeCreated){
                        continue firstFor
                    }
                }
                var enc = Contact2.addEncrypted(encryptedBody: encryptedBody, messageType: messageType!, receiverId: receiverId!, senderId: senderId!, timeCreated: timeCreated!, senderNickname: senderNickname, senderKey: senderKey)
                enc.checkAndSearch()
            }
        
    }

    static func fetchEncrypted(ascending: Bool = false) -> [Encrypted2] {
        return Encrypted2.encrypteds!
    }
    
    //    autodelete encrypted based on the id.maxEncrypted
    static func checkMaxEncrypted() {
        let listSize = Encrypted2.fetchEncrypted().count
        let identity = Identity2.fetchIdentity()
        if (listSize > identity.maxEncrypted) {
            let ecs = Encrypted2.fetchEncrypted().sorted()
            ecs[0].delete()
        }
    }
    
    //    search if this encrypted is for me and search the contact who send this message
    //    if no existing contact exists, create contact
    //    TODO: need func for input->encrypted
    //  TODO: check max encrypted
    //    TODO: untested yet
    func checkAndSearch() {
        let identity = Identity2.fetchIdentity()
        if (self.receiverId != identity.id) {
            // Read in stored identity
            Encrypted2.checkMaxEncrypted()
        } else {
            var ct = Contact2.searchOrCreate(nn: self.senderNickname!, id: self.senderId!)
          //  ct = ct.fetchcontactid(objectid: ct)
            self.decryptTo(contact: &ct)
            self.delete()
        }
    }
    
    //    decrypt the encrypt with my key
    func decryptTo(contact: inout Contact2) {
        var newMessage = Message2(messageType: self.messageType, sentByMe: false)
        newMessage.contact = contact
        newMessage.timeCreated = self.timeCreated
        newMessage.messageBody = Encrypted2.decryptToString(privateKey: Identity2.retrievePrivateKey(), body: self.encryptedBody!)
        newMessage.sentByMe = false
        contact.updateLatest(timeCreated: newMessage.timeCreated)
        if contact.messages == nil{
            contact.messages = Array<Message2>()
        }
        contact.messages!.append(newMessage)
    }
    
    // decrypt body with private key and return the converted string
    static func decryptToString(privateKey: SecKey, body: Data) -> String {
        var error: Unmanaged<CFError>?
        let decryptedBody: Data = SecKeyCreateDecryptedData(privateKey, SecKeyAlgorithm.rsaEncryptionOAEPSHA256, body as CFData, &error)! as Data
        return String(decoding: decryptedBody, as: UTF8.self)
    }

    //    delete
    func delete() {
        // reimplement
        return
    }
}


extension Encrypted : Identifiable {

}

