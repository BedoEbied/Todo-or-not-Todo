//
//  TaskFormatter.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//


import SwiftUI

struct TaskFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    static func priorityIcon(for priority: String) -> (systemName: String, color: Color)? {
        switch priority {
        case Strings.Priority.high:
            return ("exclamationmark.circle.fill", .red)
        case Strings.Priority.medium:
            return ("exclamationmark.circle.fill", .orange)
        case Strings.Priority.low:
            return ("exclamationmark.circle.fill", .yellow)
        default:
            return nil
        }
    }
    
    static func validateTitle(_ title: String) -> String? {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        if trimmedTitle.isEmpty {
            return Strings.Task.Validation.titleRequired
        }
        if trimmedTitle.count < 3 {
            return Strings.Task.Validation.titleMinLength
        }
        return nil
    }
}
