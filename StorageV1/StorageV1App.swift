//
//  StorageV1App.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//

import SwiftUI
import CoreBluetooth
import os

@main
struct StorageV1App: App {
   
    let bluetoothController = BTController2.shared
    @Environment(\.managedObjectContext) var viewContext

    var body: some Scene {
        WindowGroup {
            if Identity2.hasIdentity() {
                SplashView2(username: Identity2.fetchIdentity().nickname!)
            }
            else {
                SplashView()
            }
        }
       
    }
}
