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
    
    // MARK: - Computed Properties
    var isValidForm: Bool {
        title.trimmingCharacters(in: .whitespaces).count >= 3
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
        guard isValidForm else {
            formError = formValidationError
            return false
        }
        
        let newTask = Task(context: context)
        newTask.title = title.trimmingCharacters(in: .whitespaces)
        newTask.details = details.trimmingCharacters(in: .whitespaces)
        newTask.dueDate = dueDate
        newTask.priority = priority.rawValue
        newTask.isCompleted = false
        
        do {
            try context.save()
            print("Task Saved Successfully")
            resetForm()
            return true
        } catch {
            formError = "Failed to save task: \(error.localizedDescription)"
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