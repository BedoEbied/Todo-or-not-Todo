//
//  TaskPriority.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//


import Foundation
import CoreData
import SwiftUI

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
    init(taskService: TaskServiceProtocol = TaskService()) {
        self.taskService = taskService
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
    func saveTask(context: NSManagedObjectContext) -> Bool {
        if let error = TaskFormatter.validateTitle(title) {
            formError = error
            return false
        }
        
        isSaving = true
        formError = nil
        
        do {
            try taskService.createTask(
                title: title.trimmingCharacters(in: .whitespaces),
                details: details.trimmingCharacters(in: .whitespaces),
                dueDate: dueDate,
                priority: priority.rawValue,
                context: context
            )
            resetForm()
            isSaving = false
            return true
        } catch {
            formError = error.localizedDescription
            isSaving = false
            return false
        }
    }
    
    func resetForm() {
        title = ""
        details = ""
        dueDate = Date()
        priority = .none
        formError = nil
    }
} 
