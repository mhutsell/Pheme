//
//  Identity2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation

struct Identity2: Identifiable, Hashable, Codable{
	
	static func == (lhs: Identity2, rhs: Identity2) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id: UUID
    public var nickname: String
    public var maxEncrypted: Int
    public var privateKey: Data
    public var publicKey: Data
    public var helpOthers: Bool
    
    public init (
		id: UUID = UUID(),
		nickname: String? = nil
     ) {
        self.nickname = nickname!
        self.id = id
        self.maxEncrypted = 50
        self.helpOthers = true
        var publicKeySec, privateKeySec: SecKey?
        let keyattribute = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String : 2048
        ] as CFDictionary
        SecKeyGeneratePair(keyattribute, &publicKeySec, &privateKeySec)
        var error: Unmanaged<CFError>?
        self.publicKey = (SecKeyCopyExternalRepresentation(publicKeySec!, &error) as Data?)!
        self.privateKey = (SecKeyCopyExternalRepresentation(privateKeySec!, &error) as Data?)!
	 }
	 
	func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func fetchIdentity() -> Identity2 {
        return Identity.sharedInstance.idtt
    }
    
    //  return a tuple for showing publickey, nickname, UUID, for QR
    func myKey() -> String {
        return self.publicKey.base64EncodedString()
    }

    func myName() -> String {
        return self.nickname
    }

    func myID() -> String {
        return self.id.uuidString
    }

    // delete
    func delete() {
        //TODO
    }

}
