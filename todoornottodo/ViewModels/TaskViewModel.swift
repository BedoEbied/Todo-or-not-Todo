//
//  TaskPriority.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//


import Foundation
import CoreData
import SwiftUI
import _Concurrency

@MainActor
class TaskViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title: String = ""
    @Published var details: String = ""
    @Published var dueDate: Date = Date()
    @Published var priority: TaskPriority = .none
    @Published private(set) var formError: String?
    @Published private(set) var isSaving = false
    
    // MARK: - Dependencies
    private let taskService: TaskServiceProtocol
    
    // MARK: - Initialization
    init(taskService: TaskServiceProtocol? = nil, context: NSManagedObjectContext) {
        self.taskService = taskService ?? TaskService(repository: CoreDataTaskRepository(context: context))
    }
    
    // MARK: - Computed Properties
    var isValidForm: Bool {
        TaskFormatter.validateTitle(title) == nil
    }
    
    var formValidationError: String? {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Title is required"
        }
        if title.trimmingCharacters(in: .whitespaces).count < 3 {
            return "Title must be at least 3 characters"
        }
        return nil
    }
    
    // MARK: - Public Methods
    func saveTask() -> Bool {
        if let error = TaskFormatter.validateTitle(title) {
            formError = error
            return false
        }
        
        isSaving = true
        formError = nil
        
        _Concurrency.Task {
            do {
                try await taskService.createTask(
                    title: title.trimmingCharacters(in: .whitespaces),
                    details: details.trimmingCharacters(in: .whitespaces),
                    dueDate: dueDate,
                    priority: priority.rawValue
                )
                resetForm()
                isSaving = false
                TaskState.shared.triggerRefresh()
                return true
            } catch {
                formError = error.localizedDescription
                isSaving = false
                return false
            }
        }
        
        return true  // Return true to dismiss the form, the actual save happens async
    }
    
    func resetForm() {
        title = ""
        details = ""
        dueDate = Date()
        priority = .none
        formError = nil
    }
}
