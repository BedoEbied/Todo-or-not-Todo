//
//  TaskRepository.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//

import Foundation

// Data Transfer Object for Task
struct TaskDTO {
    let id: UUID
    var title: String
    var details: String
    var dueDate: Date
    var priority: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, details: String, dueDate: Date, priority: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
    }
}

// Repository Protocol
protocol TaskRepository {
    func fetchTasks() async throws -> [TaskDTO]
    func createTask(_ task: TaskDTO) async throws
    func updateTask(_ task: TaskDTO) async throws
    func deleteTask(id: UUID) async throws
    func deleteTasks(ids: [UUID]) async throws
}

// Repository Errors
enum TaskRepositoryError: LocalizedError {
    case saveFailed(String)
    case fetchFailed(String)
    case deleteFailed(String)
    case updateFailed(String)
    case entityNotFound
    
    var errorDescription: String? {
        switch self {
        case .saveFailed(let message): return "Failed to save task: \(message)"
        case .fetchFailed(let message): return "Failed to fetch tasks: \(message)"
        case .deleteFailed(let message): return "Failed to delete task: \(message)"
        case .updateFailed(let message): return "Failed to update task: \(message)"
        case .entityNotFound: return "Task not found"
        }
    }
}