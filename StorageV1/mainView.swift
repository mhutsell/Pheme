//
//  mainView.swift
//  StorageV1
//
//  Created by Chen Gong on 11/4/21.
//

import SwiftUI
import CoreData

struct MainView: View {
 
    let persistenceController = PersistenceController.shared
    init() {
//        /* For iOS 15 */
//        if #available(iOS 15, *) {
//            UITableView.appearance().sectionHeaderTopPadding = 0
//        }
    }
    
    var body: some View {
        TabView {
//            Contacts()
//                .tabItem {
//                    Label("Contacts", systemImage: "star")
//                }
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            ContentView()
//                .tabItem {
//                    Label("EnternApp", systemImage: "radio")
//                }
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//

        }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
