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
    
    // FetchRequest for Pending Tasks
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
        predicate: NSPredicate(format: "isCompleted == %@", NSNumber(booleanLiteral: false)),
        animation: .default)
    private var pendingTasks: FetchedResults<Task>
    
    // FetchRequest for Completed Tasks
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
        predicate: NSPredicate(format: "isCompleted == %@", NSNumber(booleanLiteral: true)),
        animation: .default)
    private var completedTasks: FetchedResults<Task>
    
    @State private var showForm = false
    
    var body: some View {
        NavigationView {
            List {
                // Pending Tasks Section
                if !pendingTasks.isEmpty {
                    Section(header: Text("Pending")) {
                        ForEach(pendingTasks) { task in
                            TaskRow(task: task)
                        }
                        .onDelete(perform: deletePendingTasks)
                    }
                }
                
                // Completed Tasks Section
                if !completedTasks.isEmpty {
                    Section(header: Text("Completed")) {
                        ForEach(completedTasks) { task in
                            TaskRow(task: task)
                        }
                        .onDelete(perform: deleteCompletedTasks)
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
                    .environment(\.managedObjectContext, viewContext)
                    .presentationDetents([.medium, .large])

            }
        }
    }
    
    private func deletePendingTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { pendingTasks[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                
                print("Error deleting tasks: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func deleteCompletedTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { completedTasks[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Handle the error appropriately
                print("Error deleting tasks: \(error.localizedDescription)")
            }
        }
    }
    
    struct TaskRow: View {
        @ObservedObject var task: Task
        @Environment(\.managedObjectContext) private var viewContext
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.title ?? "Untitled")
                        .font(.headline)
                    Text(task.details ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Due: \(task.dueDate ?? Date(), formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                priorityIcon()
                    .padding()
                Button(action: {
                    task.isCompleted.toggle()
                    saveContext()
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        
        private func saveContext() {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
        
        private func priorityIcon() -> some View {
               switch task.priority {
               case "High":
                   return AnyView(
                       Image(systemName: "exclamationmark.circle.fill")
                           .foregroundColor(.red)
                           .font(.title2)
                   )
               case "Medium":
                   return AnyView(
                       Image(systemName: "exclamationmark.circle.fill")
                           .foregroundColor(.orange)
                           .font(.title2)
                   )
               case "Low":
                   return AnyView(
                       Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                   )
               case "None":
                   return AnyView(EmptyView()) // No icon 
               default:
                   return AnyView(EmptyView())
               }
           }
        
        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }
    }
}

#Preview {
    ListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
