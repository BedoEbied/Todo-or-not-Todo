//
//  CoreDataTaskRepository.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//

import Foundation
import CoreData

class CoreDataTaskRepository: TaskRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchTasks() async throws -> [TaskDTO] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)]
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks.map { task in
                TaskDTO(
                    id: task.id ?? UUID(),
                    title: task.title ?? "",
                    details: task.details ?? "",
                    dueDate: task.dueDate ?? Date(),
                    priority: task.priority ?? "",
                    isCompleted: task.isCompleted
                )
            }
        } catch {
            throw TaskRepositoryError.fetchFailed(error.localizedDescription)
        }
    }
    
    func createTask(_ taskDTO: TaskDTO) async throws {
        let task = Task(context: context)
        task.id = taskDTO.id
        task.title = taskDTO.title
        task.details = taskDTO.details
        task.dueDate = taskDTO.dueDate
        task.priority = taskDTO.priority
        task.isCompleted = taskDTO.isCompleted
        
        do {
            try context.save()
        } catch {
            throw TaskRepositoryError.saveFailed(error.localizedDescription)
        }
    }
    
    func updateTask(_ taskDTO: TaskDTO) async throws {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskDTO.id as CVarArg)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            guard let task = tasks.first else {
                throw TaskRepositoryError.entityNotFound
            }
            
            task.title = taskDTO.title
            task.details = taskDTO.details
            task.dueDate = taskDTO.dueDate
            task.priority = taskDTO.priority
            task.isCompleted = taskDTO.isCompleted
            
            try context.save()
        } catch {
            throw TaskRepositoryError.updateFailed(error.localizedDescription)
        }
    }
    
    func deleteTask(id: UUID) async throws {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            guard let task = tasks.first else {
                throw TaskRepositoryError.entityNotFound
            }
            
            context.delete(task)
            try context.save()
        } catch {
            throw TaskRepositoryError.deleteFailed(error.localizedDescription)
        }
    }
    
    func deleteTasks(ids: [UUID]) async throws {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            tasks.forEach { context.delete($0) }
            try context.save()
        } catch {
            throw TaskRepositoryError.deleteFailed(error.localizedDescription)
        }
    }
}