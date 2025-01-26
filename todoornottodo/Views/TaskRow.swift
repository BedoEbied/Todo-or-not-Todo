//
//  ListView.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 01/26/25.
//

import SwiftUI

struct TaskRow: View {
    let task: TaskDTO
    let viewModel: ListViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                Text(task.details)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Due: \(task.dueDate, formatter: ListViewModel.dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            if let priorityIcon = viewModel.priorityIcon(for: task.priority) {
                Image(systemName: priorityIcon.systemName)
                    .foregroundColor(priorityIcon.color)
                    .font(.title2)
                    .padding()
            }
            Button(action: {
                viewModel.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
