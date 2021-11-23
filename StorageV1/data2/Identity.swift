//
//  Identity.swift
//  StorageV1
//
//  Created by Chen Gong on 11/22/21.
//

import Foundation


class Identity: ObservableObject {
    @Published(persistingTo: "Identity/idtt.json") var idtt: Identity2 = Identity2(nickname: "")

//    var me: Identity2{
//        idtt
//    }
//    static func createIdentity(nickname: String) {
//
//        self.idtt.nickname = nickname
////        self.idtt.id = UUID()
//        self.idtt.createRSAKeyPair()
//    }
    init() {
        do {
            let url = persistenceFileURL(path: "Identity/idtt.json")
            let d = try Data.smartContents(of: url)
        } catch {
            fatalError("Ray legend")
        }
        
    }
    
    func hasIdentity() -> Bool {
        return idtt.nickname != ""
    }
    
    //  return a tuple for showing publickey, nickname, UUID, for QR
    func myKey() -> String {
        return idtt.publicKey.base64EncodedString()
    }

    func myName() -> String {
        return idtt.nickname
    }

    func myID() -> String {
        return idtt.id!.uuidString
    }
    
}


