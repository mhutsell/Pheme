//
//  StorageV1App.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//

import SwiftUI
import Foundation
import CoreBluetooth
import os
import Logging


private class AppState {
    let identity: Identity
    let contacts: Contacts
    let messages: Messages
    
    init() {
        let identity = Identity()
        let contacts = Contacts()
        let messages = Messages()
        self.identity = identity
        self.contacts = contacts
        self.messages = messages
    }
    
}

private let state = AppState()

@main
struct StorageV1App: App {
   
    let bluetoothController = BTController2.shared
    @Environment(\.managedObjectContext) var viewContext
    

    var body: some Scene {
        WindowGroup {
            if state.identity.hasIdentity() {
                SplashView2()
                    .environmentObject(state.identity)
                    .environmentObject(state.contacts)
                    .environmentObject(state.messages)
            }
            else {
                SplashView()
                    .environmentObject(state.identity)
                    .environmentObject(state.contacts)
                    .environmentObject(state.messages)
            }
        }
       
    }
}
