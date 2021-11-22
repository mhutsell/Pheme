//
//  PrivateKey2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation
struct PrivateKey2 {
    
    public var keyBody: Data?
    
    
    
    // convert data to private key
    func dataToKey() -> SecKey {
        let attribute = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String : kSecAttrKeyClassPrivate
        ]
        var error: Unmanaged<CFError>?
        let priKey: SecKey = SecKeyCreateWithData(self.keyBody! as CFData, attribute as CFDictionary, &error)!
        return priKey
    }
}
