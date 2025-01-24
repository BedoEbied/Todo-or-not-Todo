import Foundation
import CoreData
import SwiftUI

class ListViewModel: ObservableObject {
    @Published var pendingTasks: [Task] = []
    @Published var completedTasks: [Task] = []
    
    // MARK: - Intent(s)
    func loadTasks(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)]
        
        do {
            let allTasks = try context.fetch(fetchRequest)
            pendingTasks = allTasks.filter { !$0.isCompleted }
            completedTasks = allTasks.filter { $0.isCompleted }
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
        }
    }
    
    func deleteTask(_ task: Task, context: NSManagedObjectContext) {
        context.delete(task)
        if saveContext(context) {
            loadTasks(context: context)
        }
    }
    
    func toggleTaskCompletion(_ task: Task, context: NSManagedObjectContext) {
        task.isCompleted.toggle()
        if saveContext(context) {
            loadTasks(context: context)
        }
    }
    
    func deleteTasks(_ tasks: [Task], context: NSManagedObjectContext) {
        tasks.forEach { context.delete($0) }
        if saveContext(context) {
            loadTasks(context: context)
        }
    }
    
    @discardableResult
    private func saveContext(_ context: NSManagedObjectContext) -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("Error saving context: \(error.localizedDescription)")
            return false
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
        switch priority {
        case "High":
            return ("exclamationmark.circle.fill", .red)
        case "Medium":
            return ("exclamationmark.circle.fill", .orange)
        case "Low":
            return ("exclamationmark.circle.fill", .yellow)
        default:
            return nil
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
} 