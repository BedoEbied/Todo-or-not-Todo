//
//  TaskState.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//

import Foundation

class TaskState: ObservableObject {
    @Published var shouldRefreshTasks = false
    
    static let shared = TaskState()
    private init() {}
    
    func triggerRefresh() {
        shouldRefreshTasks = true
    }
    
    func resetRefresh() {
        shouldRefreshTasks = false
    }
}
