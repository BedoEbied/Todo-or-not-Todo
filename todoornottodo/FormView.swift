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
    @StateObject private var viewModel: TaskViewModel

    enum Priority: String, CaseIterable, Identifiable {
        case none = "None"
        case low = "Low"
        case medium = "Medium"
        case high = "High"

        var id: String { self.rawValue }
    }
    
    init() {
        _viewModel = StateObject(wrappedValue: TaskViewModel())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $viewModel.title)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    TextField("Description", text: $viewModel.details)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                }

                Section(header: Text("Due Date")) {
                    DatePicker("Select Due Date", selection: $viewModel.dueDate, displayedComponents: .date)
                }

                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $viewModel.priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if let error = viewModel.formError {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    if viewModel.saveTask(context: viewContext) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(!viewModel.isValidForm)
            )
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    FormView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
