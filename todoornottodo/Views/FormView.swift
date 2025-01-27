//
//  FormView.swift
//  todoornottodo
//
//  Created by Abdelrahman Ebied on 26/01/2025.
//


import SwiftUI
import CoreData

struct FormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: TaskViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: TaskViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TaskDetailsSection(viewModel: viewModel)
                DueDateSection(viewModel: viewModel)
                PrioritySection(viewModel: viewModel)
                
                if let error = viewModel.formError {
                    ErrorSection(error: error)
                }
            }
            .navigationTitle(Strings.Navigation.Title.addTask)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: CancelButton(action: dismiss),
                trailing: SaveButton(viewModel: viewModel, context: viewContext, onSave: dismiss)
            )
        }
        .presentationDetents([.medium, .large])
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Subviews
private struct TaskDetailsSection: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        Section(header: Text(Strings.Task.Section.taskDetails)) {
            TextField(Strings.Task.Form.Title.placeholder, text: $viewModel.title)
                .autocapitalization(.words)
                .disableAutocorrection(true)
            
            TextField(Strings.Task.Form.Description.placeholder, text: $viewModel.details)
                .autocapitalization(.sentences)
                .disableAutocorrection(true)
        }
    }
}

private struct DueDateSection: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        Section(header: Text(Strings.Task.Section.dueDate)) {
            DatePicker(Strings.Task.Form.DueDate.label, selection: $viewModel.dueDate, displayedComponents: .date)
        }
    }
}

private struct PrioritySection: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        Section(header: Text(Strings.Task.Section.priority)) {
            Picker(Strings.Task.Section.priority, selection: $viewModel.priority) {
                ForEach(TaskPriority.allCases) { priority in
                    Text(priority.rawValue).tag(priority)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private struct ErrorSection: View {
    let error: String
    
    var body: some View {
        Section {
            Text(error)
                .foregroundColor(.red)
        }
    }
}

private struct CancelButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(Strings.Common.cancel, action: action)
    }
}

private struct SaveButton: View {
    @ObservedObject var viewModel: TaskViewModel
    let context: NSManagedObjectContext
    let onSave: () -> Void
    
    var body: some View {
        Button(Strings.Common.save) {
            let success = viewModel.saveTask()
            if success {
                onSave()
            }
        }
        .disabled(!viewModel.isValidForm)
    }
}

#Preview {
    FormView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
