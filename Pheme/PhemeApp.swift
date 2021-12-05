//
//  StorageV1App.swift
//  StorageV1
//
//  Created by Chen Gong 12/4/2021
//

import SwiftUI
import Foundation
import CoreBluetooth
import os




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
