//
//  TaskService.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//

import Foundation
import CoreData

enum TaskError: Error {
    case saveFailed(String)
    case fetchFailed(String)
    case deleteFailed(String)
    case updateFailed(String)
}

protocol TaskServiceProtocol {
    func fetchTasks(context: NSManagedObjectContext) throws -> [Task]
    func createTask(title: String, details: String, dueDate: Date, priority: String, context: NSManagedObjectContext) throws
    func deleteTask(_ task: Task, context: NSManagedObjectContext) throws
    func updateTask(_ task: Task, context: NSManagedObjectContext) throws
    func deleteTasks(_ tasks: [Task], context: NSManagedObjectContext) throws
}

class TaskService: TaskServiceProtocol {
    func fetchTasks(context: NSManagedObjectContext) throws -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw TaskError.fetchFailed(error.localizedDescription)
        }
    }
    
    func createTask(title: String, details: String, dueDate: Date, priority: String, context: NSManagedObjectContext) throws {
        let task = Task(context: context)
        task.title = title
        task.details = details
        task.dueDate = dueDate
        task.priority = priority
        task.isCompleted = false
        
        do {
            try context.save()
        } catch {
            throw TaskError.saveFailed(error.localizedDescription)
        }
    }
    
    func deleteTask(_ task: Task, context: NSManagedObjectContext) throws {
        context.delete(task)
        do {
            try context.save()
        } catch {
            throw TaskError.deleteFailed(error.localizedDescription)
        }
    }
    
    func updateTask(_ task: Task, context: NSManagedObjectContext) throws {
        do {
            try context.save()
        } catch {
            throw TaskError.updateFailed(error.localizedDescription)
        }
    }
    
    func deleteTasks(_ tasks: [Task], context: NSManagedObjectContext) throws {
        tasks.forEach { context.delete($0) }
        do {
            try context.save()
        } catch {
            throw TaskError.deleteFailed(error.localizedDescription)
        }
    }
}
