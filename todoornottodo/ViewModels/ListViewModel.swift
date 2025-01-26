//
//  ListViewModel.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//


import Foundation
import CoreData
import SwiftUI

class ListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var pendingTasks: [Task] = []
    @Published private(set) var completedTasks: [Task] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading = false
    
    // MARK: - Dependencies
    private let taskService: TaskServiceProtocol
    
    // MARK: - Initialization
    init(taskService: TaskServiceProtocol = TaskService()) {
        self.taskService = taskService
    }
    
    // MARK: - Public Methods
    func loadTasks(context: NSManagedObjectContext) {
        isLoading = true
        errorMessage = nil
        
        do {
            let allTasks = try taskService.fetchTasks(context: context)
            pendingTasks = allTasks.filter { !$0.isCompleted }
            completedTasks = allTasks.filter { $0.isCompleted }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func deleteTask(_ task: Task, context: NSManagedObjectContext) {
        do {
            try taskService.deleteTask(task, context: context)
            loadTasks(context: context)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func toggleTaskCompletion(_ task: Task, context: NSManagedObjectContext) {
        task.isCompleted.toggle()
        do {
            try taskService.updateTask(task, context: context)
            loadTasks(context: context)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteTasks(_ tasks: [Task], context: NSManagedObjectContext) {
        do {
            try taskService.deleteTasks(tasks, context: context)
            loadTasks(context: context)
        } catch {
            errorMessage = error.localizedDescription
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

