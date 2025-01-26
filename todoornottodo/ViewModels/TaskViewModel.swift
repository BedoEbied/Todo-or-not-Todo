import Foundation
import CoreData
import SwiftUI

class TaskViewModel: ObservableObject {
    // MARK: - Form State
    @Published var title: String = ""
    @Published var details: String = ""
    @Published var dueDate: Date = Date()
    @Published var priority: FormView.Priority = .none
    @Published var formError: String?
    
    private let taskService: TaskServiceProtocol
    private let taskState: TaskState
    
    init(taskService: TaskServiceProtocol = TaskService(), taskState: TaskState = .shared) {
        self.taskService = taskService
        self.taskState = taskState
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
    
    // MARK: - Intent(s)
    func saveTask(context: NSManagedObjectContext) -> Bool {
        if let error = TaskFormatter.validateTitle(title) {
            formError = error
            return false
        }
        
        do {
            try taskService.createTask(
                title: title.trimmingCharacters(in: .whitespaces),
                details: details.trimmingCharacters(in: .whitespaces),
                dueDate: dueDate,
                priority: priority.rawValue,
                context: context
            )
            resetForm()
            taskState.triggerRefresh()
            return true
        } catch {
            formError = error.localizedDescription
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