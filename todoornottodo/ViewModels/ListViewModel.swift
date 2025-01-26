import Foundation
import CoreData
import SwiftUI

class ListViewModel: ObservableObject {
    @Published var pendingTasks: [Task] = []
    @Published var completedTasks: [Task] = []
    @Published var errorMessage: String?
    
    private let taskService: TaskServiceProtocol
    private let taskState: TaskState
    
    init(taskService: TaskServiceProtocol = TaskService(), taskState: TaskState = .shared) {
        self.taskService = taskService
        self.taskState = taskState
    }
    
    // MARK: - Intent(s)
    func loadTasks(context: NSManagedObjectContext) {
        do {
            let allTasks = try taskService.fetchTasks(context: context)
            pendingTasks = allTasks.filter { !$0.isCompleted }
            completedTasks = allTasks.filter { $0.isCompleted }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteTask(_ task: Task, context: NSManagedObjectContext) {
        do {
            try taskService.deleteTask(task, context: context)
            loadTasks(context: context)
            taskState.triggerRefresh()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func toggleTaskCompletion(_ task: Task, context: NSManagedObjectContext) {
        task.isCompleted.toggle()
        do {
            try taskService.updateTask(task, context: context)
            loadTasks(context: context)
            taskState.triggerRefresh()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteTasks(_ tasks: [Task], context: NSManagedObjectContext) {
        do {
            try taskService.deleteTasks(tasks, context: context)
            loadTasks(context: context)
            taskState.triggerRefresh()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - View Data
    struct TaskRowData: Identifiable {
        let id: NSManagedObjectID
        let title: String
        let details: String
        let dueDate: Date
        let priority: String
        let isCompleted: Bool
        
        init(task: Task) {
            self.id = task.objectID
            self.title = task.title ?? "Untitled"
            self.details = task.details ?? ""
            self.dueDate = task.dueDate ?? Date()
            self.priority = task.priority ?? "None"
            self.isCompleted = task.isCompleted
        }
    }
    
    func priorityIcon(for priority: String) -> (systemName: String, color: Color)? {
        TaskFormatter.priorityIcon(for: priority)
    }
    
    static var dateFormatter: DateFormatter {
        TaskFormatter.dateFormatter
    }
} 