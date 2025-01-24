//
//  ListView.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 12/17/24.
//

import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ListViewModel
    @State private var showForm = false
    
    init() {
        _viewModel = StateObject(wrappedValue: ListViewModel())
    }
    
    var body: some View {
        NavigationView {
            List {
                if !viewModel.pendingTasks.isEmpty {
                    Section(header: Text("Pending")) {
                        ForEach(viewModel.pendingTasks) { task in
                            TaskRow(task: task, viewModel: viewModel)
                        }
                        .onDelete { indexSet in
                            viewModel.deleteTasks(indexSet.map { viewModel.pendingTasks[$0] }, context: viewContext)
                        }
                    }
                }
                
                if !viewModel.completedTasks.isEmpty {
                    Section(header: Text("Completed")) {
                        ForEach(viewModel.completedTasks) { task in
                            TaskRow(task: task, viewModel: viewModel)
                        }
                        .onDelete { indexSet in
                            viewModel.deleteTasks(indexSet.map { viewModel.completedTasks[$0] }, context: viewContext)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Todo List")
            .navigationBarItems(trailing: Button(action: {
                showForm = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showForm) {
                FormView()
            }
        }
        .onAppear {
            viewModel.loadTasks(context: viewContext)
        }
    }
}

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

#Preview {
    ListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
