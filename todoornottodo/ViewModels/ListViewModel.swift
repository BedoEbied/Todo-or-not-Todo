//
//  ListViewModel.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//

import Foundation
import CoreData
import SwiftUI
import _Concurrency

@MainActor
class ListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var pendingTasks: [TaskDTO] = []
    @Published private(set) var completedTasks: [TaskDTO] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading = false
    
    // MARK: - Dependencies
    private let taskService: TaskServiceProtocol
    
    // MARK: - Initialization
    init(taskService: TaskServiceProtocol? = nil, context: NSManagedObjectContext) {
        self.taskService = taskService ?? TaskService(repository: CoreDataTaskRepository(context: context))
    }
    
    // MARK: - Public Methods
    func loadTasks() {
        
        _Concurrency.Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let allTasks = try await taskService.fetchTasks()
                pendingTasks = allTasks.filter { !$0.isCompleted }
                completedTasks = allTasks.filter { $0.isCompleted }
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func deleteTask(_ task: TaskDTO) {
        _Concurrency.Task {
            do {
                try await taskService.deleteTask(id: task.id)
                loadTasks()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func toggleTaskCompletion(_ task: TaskDTO) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        
        _Concurrency.Task {
            do {
                try await taskService.updateTask(updatedTask)
                loadTasks()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func deleteTasks(_ tasks: [TaskDTO]) {
        _Concurrency.Task {
            do {
                try await taskService.deleteTasks(ids: tasks.map { $0.id })
                loadTasks()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - View Helpers
    func priorityIcon(for priority: String) -> (systemName: String, color: Color)? {
        TaskFormatter.priorityIcon(for: priority)
    }
    
    static var dateFormatter: DateFormatter {
        TaskFormatter.dateFormatter
    }
}

