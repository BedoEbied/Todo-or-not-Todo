//
//  todoornottodoApp.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 12/14/24.
//

import SwiftUI

@main
struct todoornottodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
