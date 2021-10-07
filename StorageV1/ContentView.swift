//
//  ContentView.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Message.timeCreated, ascending: true)],
        animation: .default)
    private var messages: FetchedResults<Message>

    var body: some View {
        List {
            ForEach(messages) { message in
                Text("Message at \(message.timeCreated!, formatter: itemFormatter)")
            }
            .onDelete(perform: deleteMessages)
        }
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif

            Button(action: addMessage) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }

    private func addMessage() {
        withAnimation {
            let newMessage = Message(context: viewContext)
            newMessage.timeCreated = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteMessages(offsets: IndexSet) {
        withAnimation {
            offsets.map { messages[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
