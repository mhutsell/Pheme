//
//  Encrypted.swift
//  StorageV1
//
//  Created by Ray Chen on 11/23/21.
//

import Foundation


class Encrypteds: ObservableObject {
	static let sharedInstance = Encrypteds()

    @Published(persistingTo: "Encrypted/encrypted.json") var encrypteds: [UUID: Encrypted2] = [:]

	init() {}
	
	init(encrypteds: [Encrypted2]) {
        self.encrypteds = Dictionary(encrypteds.map { ($0.id, $0) }, uniquingKeysWith: { k, _ in k })
    }
    
    func addEncrypted(encrypted: Encrypted2) {
		encrypteds[encrypted.id] = encrypted
		self.checkMaxEncrypted()
	}
	
	func checkMaxEncrypted() {
		while (encrypteds.keys.count > Identity2.fetchIdentity().maxEncrypted) {
			encrypteds[encrypteds.values.sorted()[0].id] = nil
		}
	}
	
	func clearEncrypted() {
		encrypteds = [:]
	}
	
	func clearAllOthers() {
		encrypteds = encrypteds.filter { $0.value.senderId == Identity2.fetchIdentity().id }
	}
	
	func clearGlobal() {
		encrypteds = encrypteds.filter { $0.value.receiverId != Identity2.globalId }
	}
	
	func clearImages() {
		encrypteds = encrypteds.filter { $0.value.messageType == 0 }
	}
	
	func deleteEncrypted(id: UUID) {
		encrypteds = encrypteds.filter { $0.value.id != id }
	}
	
	func deleteEncryptedFor(id: UUID) {
		encrypteds = encrypteds.filter { $0.value.receiverId != id }
	}
}
