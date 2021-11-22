//
//  PublicKey2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation

struct PublicKey2{

    
    static func == (lhs: PublicKey2, rhs: PublicKey2) -> Bool {
        return lhs.keyBody == rhs.keyBody
    }
    
    public var keyBody: Data?
    public var encryptedSender: Encrypted2?
    
    func dataToKey() -> SecKey {
        let attribute = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String : kSecAttrKeyClassPublic
        ]
        var error: Unmanaged<CFError>?
        let pubKey: SecKey = SecKeyCreateWithData(self.keyBody! as CFData, attribute as CFDictionary, &error)!
        return pubKey
    }

    // create public key called by createContact()
    static func createPublicKey(key: String) -> PublicKey2 {
            var newKey = PublicKey2()
            newKey.keyBody = Data(base64Encoded: key, options: .ignoreUnknownCharacters)
            return newKey
        }
}
