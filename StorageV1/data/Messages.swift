//
//  Messages.swift
//  StorageV1
//
//  Created by 龚晨 on 11/24/21.
//

import Foundation

class Messages: ObservableObject {
    @Published(persistingTo: "Contact/contact_messages.json") var messages: [UUID: Message2] = [:]
    
    init() {}
    
    subscript(contactId: UUID) -> [Message2] {
        messages.values
            .filter { $0.contactId == contactId }
            .sorted { $0.timeCreated < $1.timeCreated }
    }
    
    
    
}
