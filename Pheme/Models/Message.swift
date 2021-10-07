//
//  Message.swift
//  Pheme
//
//  Created by William Mack Hutsell on 10/3/21.
//

import Foundation

struct Message {
    
    var text : String
    var isSent : Bool
    
    init(text: String, isSent: Bool) {
        
        self.text = text
        self.isSent = isSent
    }
}
