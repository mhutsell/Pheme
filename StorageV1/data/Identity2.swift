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
    public var globalChatroom: Bool
	
	static public var globalId = UUID(uuidString: "92B538F1-A09F-40EE-83F2-482307338E0B")!
	static public var globalPublicKey = stringToKeyBody(key: "MIIBCgKCAQEA5eE5UosaqgmErEDqybF5OS6OwTBOTdh3LB/Q3Pek/tEX/E35tytcvL8Ow5t8IbmGPZhpkv01uXLxt8hCiBbihWWqdlm9ZbiBj7bJjMQ9kmh/eahHZPZR3GCDouJ4T5wmvrcMv7L0z3hTPrY03bt6mruJOEHtXsb+K6e/89p0ArNyBfcmD7iBsikmbRABoHjYrOxOkksV7KkY2VFWa2/vaD65YqJC10nEm5HWtx0lkL/HX6o/nDUAHdFiywoSuYDFdnKaxAkHu5MM6g2BoK5nFvPLTI9s+I7qCSO4V1METtdFZNtRKUb753DfW9NiNA95TmkNLtSBc/pZEk10ZB7DAwIDAQAB")
	static public var globalPrivateKey = stringToKeyBody(key: "MIIEogIBAAKCAQEA5eE5UosaqgmErEDqybF5OS6OwTBOTdh3LB/Q3Pek/tEX/E35tytcvL8Ow5t8IbmGPZhpkv01uXLxt8hCiBbihWWqdlm9ZbiBj7bJjMQ9kmh/eahHZPZR3GCDouJ4T5wmvrcMv7L0z3hTPrY03bt6mruJOEHtXsb+K6e/89p0ArNyBfcmD7iBsikmbRABoHjYrOxOkksV7KkY2VFWa2/vaD65YqJC10nEm5HWtx0lkL/HX6o/nDUAHdFiywoSuYDFdnKaxAkHu5MM6g2BoK5nFvPLTI9s+I7qCSO4V1METtdFZNtRKUb753DfW9NiNA95TmkNLtSBc/pZEk10ZB7DAwIDAQABAoIBAGpfW90cTUxddy0WJQ8LtqKFLr2qkrFm905NsqJtXcYkD0tK8cCWqiUU68oMCta4OKwL+N5xmQilbcCzREYhANTlhImbYQ7O3/UWihE/RZaYEFTFT7QiXyLw7jjTPwTnpu4dWiLitnHCphKg0bnA5SzwlsCXkTWIM1kUGLjIX2JXsmluITjJS+j9iJA8HjHFxMBe0/Sp3gT/mHOr0PWDtLnaLXjtOCN4UFN7QoUkU2GyCn8nlcAZmagG90UPUnia+pluZCUhMvgU1YHKAe6iNIBQGa8nI4wFma6ClFSlwi5qYw76nJbOMIaKqUxr1v09QUz552ggz+UEcYs0XMIBEIECgYEA9G0dyjjY/5KgQpJMIYKhiGKA+OmqyeLgCRQ9nKa1rgkzkPxVWRCZHVH4lh5FPnzm1Pp6E0Ye9TJI0Ya6xDu3goyU/7JUgjRaFMp7XnG10vIBEU968a8NB0xM+TXJp7AItf08wI2oWGWfEzjnMyYZs4By7aLa9AI9sIbFNc2pPeMCgYEA8MPHSciRkc4lP8kZfI6nqjFM9X8LWP9JjCM/0bs7zFLhSw0vYB8e1cB1uuVEOInu9f+Ioi8GG2Jizj+txadS0MeVmjqitX/c9ZGWU6qn/E8vUgLhgVr0dSXZpLce+Ucx9L47plu+c8n8NZi9qJ8RsWQK/NWrC6F603cSD/hZcGECgYA+DY2ojzIYACOLgxSs1TspIsjXaIshYeW6qFbT9EbffhqHTmhkiiA1H2BazCiMKq13mHdxeTXWzgNKnkfAFeEK1aHmIGHwBFZyPM2BNqEQgrvepyzxOp22IprQEeW2Gqy7dyT7RXtdpb7y5Fld1Ohld9C1n8iydfcvX6eldybmPQKBgBtQaqyBN5qOA4XP/7c0y+qv+yYiypvHIoXmfdgCYM9WW77S+Rvzi+D+G50fY3TymQyJd+vGX+/9Ym45pTI2QFv1OJCttEXZAq1NXfuR8crbBOhN8V1mfzNHHwDj0XzASfeVGVlPMTUbpiRCdsnJeg1g5yo151jDchbJfGAZcbQhAoGAF/9V3gwAne41J/g9uILdQ+RPHnHjLm0VS3zDYRtDb5AxM9csEYUqIQ85qVdz41/XTezZnJ6xgindP99kt8inkVEqcBLYiwjf8gSMP0DFQVT+5ptDoRJnhHSn1djLbiCP9k8b/XS88z08KoOdbutyvrHEO1Fxh7h6/KvahmPteYc=")
    
    public init (
		id: UUID = UUID(),
		nickname: String? = nil
     ) {
        self.nickname = nickname!
        self.id = id
        self.maxEncrypted = 50
        self.helpOthers = true
        self.globalChatroom = true
        var publicKeySec, privateKeySec: SecKey?
        let keyattribute = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String : 2048
        ] as CFDictionary
        SecKeyGeneratePair(keyattribute, &publicKeySec, &privateKeySec)
        var error: Unmanaged<CFError>?
        self.publicKey = (SecKeyCopyExternalRepresentation(publicKeySec!, &error) as Data?)!
        self.privateKey = (SecKeyCopyExternalRepresentation(privateKeySec!, &error) as Data?)!
		Contacts.sharedInstance.searchOrCreate(nn: "Global Chatroom", id: Identity2.globalId, keyBody: Identity2.globalPublicKey)
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


}
