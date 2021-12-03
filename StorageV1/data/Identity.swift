//
//  Identity.swift
//  StorageV1
//
//  Created by Chen Gong on 11/22/21.
//

import Foundation


class Identity: ObservableObject {

	static let sharedInstance = Identity()
	
    @Published(persistingTo: "Identity/idtt.json") var idtt: Identity2 = Identity2(nickname: "")

	init() {}
    
    func hasIdentity() -> Bool {
        return idtt.nickname != ""
    }

    //  update the max number of encrypte stored
    func updateMaxEncrypted(max: Int) {
        idtt.maxEncrypted = max
        Encrypteds.sharedInstance.checkMaxEncrypted()
    }
    
    //	update if you want to help others
    func updateHelpOthers() {
		idtt.helpOthers = !idtt.helpOthers
		if !idtt.helpOthers {
			Encrypteds.sharedInstance.clearAllOthers()
		}
	}
	
	//	update if you want to enable global chatroom
    func updateGlobalChatroom() {
		idtt.globalChatroom = !idtt.globalChatroom
		if !idtt.globalChatroom {
			Encrypteds.sharedInstance.clearGlobal()
		}
	}
    
}


