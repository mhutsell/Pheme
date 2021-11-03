//
//  StorageV1App.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//

import SwiftUI

@main
struct StorageV1App: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) var viewContext

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: viewContext) {_ in
			persistenceController.save()
		}
    }
}
