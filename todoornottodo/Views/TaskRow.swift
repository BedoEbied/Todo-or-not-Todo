//
//  ListView.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 01/26/25.
//

import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: Task
    let viewModel: ListViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title ?? "Untitled")
                    .font(.headline)
                Text(task.details ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Due: \(task.dueDate ?? Date(), formatter: ListViewModel.dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            if let priorityIcon = viewModel.priorityIcon(for: task.priority ?? "None") {
                Image(systemName: priorityIcon.systemName)
                    .foregroundColor(priorityIcon.color)
                    .font(.title2)
                    .padding()
            }
            Button(action: {
                viewModel.toggleTaskCompletion(task, context: task.managedObjectContext!)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
} 
