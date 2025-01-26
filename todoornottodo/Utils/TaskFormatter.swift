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
    
    static func validateTitle(_ title: String) -> String? {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        if trimmedTitle.isEmpty {
            return "Title is required"
        }
        if trimmedTitle.count < 3 {
            return "Title must be at least 3 characters"
        }
        return nil
    }
} 
