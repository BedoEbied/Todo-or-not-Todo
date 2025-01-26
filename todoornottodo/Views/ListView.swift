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
            ZStack {
                List {
                    TasksSection(
                        title: "Pending",
                        tasks: viewModel.pendingTasks,
                        viewModel: viewModel
                    )
                    
                    TasksSection(
                        title: "Completed",
                        tasks: viewModel.completedTasks,
                        viewModel: viewModel
                    )
                }
                .listStyle(InsetGroupedListStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                }
                
                if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        viewModel.loadTasks(context: viewContext)
                    }
                }
            }
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

// MARK: - Subviews
private struct TasksSection: View {
    let title: String
    let tasks: [Task]
    let viewModel: ListViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        if !tasks.isEmpty {
            Section(header: Text(title)) {
                ForEach(tasks) { task in
                    TaskRow(task: task, viewModel: viewModel)
                }
                .onDelete { indexSet in
                    viewModel.deleteTasks(indexSet.map { tasks[$0] }, context: viewContext)
                }
            }
        }
    }
}

private struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Retry", action: retryAction)
                .buttonStyle(.bordered)
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding()
    }
}

#Preview {
    ListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 
