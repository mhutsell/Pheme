//
//  Message2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation
struct Message2: Comparable{
    static func < (lhs: Message2, rhs: Message2) -> Bool {
        return lhs.timeCreated! < rhs.timeCreated!
    }
    
    static func == (lhs: Message2, rhs: Message2) -> Bool {
        return lhs.timeCreated! == rhs.timeCreated!
    }
    
     public var messageBody: String?
     public var messageType: Int16
     public var timeCreated: Date?
     public var sentByMe: Bool
     public var contact: Contact2?
    
    func encryptAndQueue() {
        let identity = Identity2.fetchIdentity()
        var newEncrypted = Encrypted2(messageType: self.messageType)
        newEncrypted.receiverId = self.contact!.id
        newEncrypted.senderId = identity.id
        newEncrypted.messageType = self.messageType
        newEncrypted.timeCreated = self.timeCreated
        newEncrypted.senderKey = identity.publicKey.base64EncodedString()
        newEncrypted.senderNickname = identity.nickname
        newEncrypted.encryptedBody = Message2.encryptToData(publicKey: self.contact!.theirKey!.dataToKey(), msBody: self.messageBody!)
        if Encrypted2.encrypteds == nil{
            Encrypted2.encrypteds = Array<Encrypted2>()
        }
        Encrypted2.encrypteds!.append(newEncrypted)
        BTController2.shared.createPayload()
    }
    
    // encrypt string with public key and return the converted data
    static func encryptToData(publicKey: SecKey, msBody: String) -> Data {
        let bodyData: CFData = msBody.data(using: .utf8)! as CFData
        var error: Unmanaged<CFError>?
        let encryptedBody: Data = SecKeyCreateEncryptedData(publicKey, SecKeyAlgorithm.rsaEncryptionOAEPSHA256, bodyData, &error)! as Data
        return encryptedBody
    }
    
    static func sortByDate(list: [Message2]) -> [Message2] {
        let returnList: [Message2] = list
        return  returnList.sorted{ $0.timeCreated! > $1.timeCreated! }
    }
    
    //    delete
    func delete() {
        //TODO
    }
}
