//
//  TodoApp.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 12/14/24.
//

import SwiftUI

@main
struct TodoApp: App {
    let persistenceController: PersistenceController
    let taskService: TaskServiceProtocol
    
    init() {
        persistenceController = PersistenceController.shared
        taskService = TaskService()
    }
    
    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
} 
