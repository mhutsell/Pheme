//
//  PrivateKey2.swift
//  StorageV1
//
//  Created by William Mack Hutsell on 11/21/21.
//

import Foundation
struct PrivateKey2: Identifiable, Hashable, Codable{
	
	static func == (lhs: PrivateKey2, rhs: PrivateKey2) -> Bool {
        return lhs.keyBody == rhs.keyBody
    }
    
    public var id: UUID?
    public var keyBody: Data?
    
    public init (
		id: UUID = UUID(),
		keyBody: Data? = nil
     ) {
		self.id = id
		self.keyBody = keyBody
	 }
	 
	  public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
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
