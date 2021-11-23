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
    
    init() {
        let identity = Identity()
        let contacts = Contacts()
        self.identity = identity
        self.contacts = contacts
    }
    
}

private let state = AppState()

@main
struct StorageV1App: App {
   
//    let bluetoothController = BTController2.shared
    @Environment(\.managedObjectContext) var viewContext
//    private let logger = Logger(label: "Pheme.App")
//    var p = Profile()
    

    var body: some Scene {
        WindowGroup {
            if state.identity.hasIdentity() {
                SplashView2()
                    .environmentObject(state.identity)
                    .environmentObject(state.contacts)
            }
            else {
                SplashView()
                    .environmentObject(state.identity)
                    .environmentObject(state.contacts)
            }
        }
       
    }
}
