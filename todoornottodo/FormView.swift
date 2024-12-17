//
//  FormView.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 12/15/24.
//

import SwiftUI
import CoreData

struct FormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var details: String = ""
    @State private var dueDate: Date = Date()
    @State private var priority: Priority = .none

    enum Priority: String, CaseIterable, Identifiable {
        case none = "None"
        case low = "Low"
        case medium = "Medium"
        case high = "High"

        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    TextField("Description", text: $details)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                }

                Section(header: Text("Due Date")) {
                    DatePicker("Select Due Date", selection: $dueDate, displayedComponents: .date)
                }

                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveTask()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty) // Disable save if title is empty
            )
        }
        .presentationDetents([.medium, .large])
}


    private func saveTask() {
        let newTask = Task(context: viewContext)
        newTask.title = title.trimmingCharacters(in: .whitespaces)
        newTask.details = details.trimmingCharacters(in: .whitespaces)
        newTask.dueDate = dueDate
        newTask.priority = priority.rawValue
        newTask.isCompleted = false

        do {
            try viewContext.save()
            print("Task Saved Successfully")
        } catch {
            // Handle the Core Data error appropriately
            print("Failed to save task: \(error.localizedDescription)")
        }
    }
}

#Preview {
    FormView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

}
