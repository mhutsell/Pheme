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
    
    static public var me: Identity2?
    public var id: UUID?
    public var nickname: String?
    public var maxEncrypted: Int16
//    public var contacts: NSSet?
//    public var notMine: NSSet?
    public var privateKey: PrivateKey2?
    public var publicKey: PublicKey2?
    
    public init (
		id: UUID = UUID(),
		nickname: String? = nil,
		maxEncrypted: Int16 = 50
     ) {
		self.id = id
		self.maxEncrypted = maxEncrypted
		self.nickname = nickname
	 }
	 
	 public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func fetchIdentity() -> Identity2 {
        // Read in identity and return it
        return Identity2.me!
//        let fr: Array<Identity> = Identity2.fetchRequest()
//        fr.fetchLimit = 1
//        do {
//            if (!Identity2.hasIdentity()) {
//                Identity2.createIdentity(nickname: "TEMPORARY")
//            }
//            let identity = Identity2.fetchIdentity()
//            return identity
//        } catch {let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
    }


    //    return if there is an identity
    //    TODO: untested yet
    static func hasIdentity() -> Bool {
        return Identity2.me != nil
    }

    //    no check for existing identity
    static func createIdentity(nickname: String) {
        var newIdentity = Identity2(maxEncrypted: 50)
        newIdentity.nickname = nickname
        newIdentity.id = UUID()
        newIdentity.createRSAKeyPair()
        Identity2.me = newIdentity
    }

    //    generate new rsa key pair with random data for the identity
    //    merge create private and publickey into this func because they won't be used otherwise
    mutating func createRSAKeyPair() {
        var publicKeySec, privateKeySec: SecKey?
        let keyattribute = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String : 2048
        ] as CFDictionary
        SecKeyGeneratePair(keyattribute, &publicKeySec, &privateKeySec)
        
        var error: Unmanaged<CFError>?
        var priKey = PrivateKey2()
        priKey.keyBody = SecKeyCopyExternalRepresentation(privateKeySec!, &error) as Data?
        
        var pubKey = PublicKey2()
        pubKey.keyBody = SecKeyCopyExternalRepresentation(publicKeySec!, &error) as Data?
        
        self.publicKey = pubKey
        self.privateKey = priKey
    }

    //  return a tuple for showing publickey, nickname, UUID, for QR
    static func myKey() -> String {
        let identity = Identity2.fetchIdentity()
        return identity.publicKey!.keyBody!.base64EncodedString()
    }

    static func myName() -> String {
        let identity = Identity2.fetchIdentity()
        return identity.nickname!
    }

    static func myID() -> String {
        let identity = Identity2.fetchIdentity()
        return identity.id!.uuidString
    }

    //    update the max number of encrypte stored
    mutating func updateMaxEncrypted(max: Int16) {
        self.maxEncrypted = max
    
    }

    // retrieve my own private key
    static func retrievePrivateKey() -> SecKey {
        return self.fetchIdentity().privateKey!.dataToKey()
    }

    // delete
    func delete() {
        //TODO
    }

}
