//
//  TaskService.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//

import Foundation
import CoreData

protocol TaskServiceProtocol {
    func fetchTasks() async throws -> [TaskDTO]
    func createTask(title: String, details: String, dueDate: Date, priority: String) async throws
    func deleteTask(id: UUID) async throws
    func updateTask(_ task: TaskDTO) async throws
    func deleteTasks(ids: [UUID]) async throws
}

class TaskService: TaskServiceProtocol {
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func fetchTasks() async throws -> [TaskDTO] {
        try await repository.fetchTasks()
    }
    
    func createTask(title: String, details: String, dueDate: Date, priority: String) async throws {
        let task = TaskDTO(
            title: title,
            details: details,
            dueDate: dueDate,
            priority: priority
        )
        try await repository.createTask(task)
    }
    
    func deleteTask(id: UUID) async throws {
        try await repository.deleteTask(id: id)
    }
    
    func updateTask(_ task: TaskDTO) async throws {
        try await repository.updateTask(task)
    }
    
    func deleteTasks(ids: [UUID]) async throws {
        try await repository.deleteTasks(ids: ids)
    }
}
