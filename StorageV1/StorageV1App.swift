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



@main
struct StorageV1App: App {
   
    var bluetoothController = BTController2.shared
    @Environment(\.managedObjectContext) var viewContext
    

    var body: some Scene {
        WindowGroup {
            if Identity.sharedInstance.hasIdentity() {
                SplashView2()
            }
            else {
                SplashView()
            }
        }
       
    }
}
