//
//  Identity.swift
//  StorageV1
//
//  Created by Chen Gong on 11/22/21.
//

import Foundation


class Identity: ObservableObject {
    @Published(persistingTo: "Identity/idtt.json") var idtt: Identity2 = Identity2(nickname: "")

	init() {}
    
    func hasIdentity() -> Bool {
        return idtt.nickname != ""
    }
    
    func fetchIdentity() -> Identity2 {
		return idtt
	}
    
    //  return a tuple for showing publickey, nickname, UUID, for QR
    func myKey() -> String {
        return idtt.publicKey.base64EncodedString()
    }

    func myName() -> String {
        return idtt.nickname
    }

    func myID() -> String {
        return idtt.id.uuidString
    }
    
    //  update the max number of encrypte stored
    func updateMaxEncrypted(max: Int16) {
        idtt.maxEncrypted = max
    }
    
    //	update if you want to help others
    func updateHelpOthers() {
		idtt.helpOthers = !idtt.helpOthers
		if !idtt.helpOthers {
			let encrypteds = Encrypted()
			encrypteds.clearAllOthers()
		}
	}
    
}


