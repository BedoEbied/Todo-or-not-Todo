// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Common {
    /// Cancel
    internal static let cancel = Strings.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// Retry
    internal static let retry = Strings.tr("Localizable", "common.retry", fallback: "Retry")
    /// Save
    internal static let save = Strings.tr("Localizable", "common.save", fallback: "Save")
  }
  internal enum Navigation {
    internal enum Title {
      /// Add New Task
      internal static let addTask = Strings.tr("Localizable", "navigation.title.add_task", fallback: "Add New Task")
      /// Todo List
      internal static let todoList = Strings.tr("Localizable", "navigation.title.todo_list", fallback: "Todo List")
    }
  }
  internal enum Priority {
    /// High
    internal static let high = Strings.tr("Localizable", "priority.high", fallback: "High")
    /// Low
    internal static let low = Strings.tr("Localizable", "priority.low", fallback: "Low")
    /// Medium
    internal static let medium = Strings.tr("Localizable", "priority.medium", fallback: "Medium")
    /// None
    internal static let `none` = Strings.tr("Localizable", "priority.none", fallback: "None")
  }
  internal enum Task {
    internal enum Form {
      internal enum Description {
        /// Description
        internal static let placeholder = Strings.tr("Localizable", "task.form.description.placeholder", fallback: "Description")
      }
      internal enum DueDate {
        /// Select Due Date
        internal static let label = Strings.tr("Localizable", "task.form.due_date.label", fallback: "Select Due Date")
      }
      internal enum Error {
        /// Title must be at least 3 characters
        internal static let titleMinLength = Strings.tr("Localizable", "task.form.error.title_min_length", fallback: "Title must be at least 3 characters")
        /// Title is required
        internal static let titleRequired = Strings.tr("Localizable", "task.form.error.title_required", fallback: "Title is required")
      }
      internal enum Title {
        /// Title
        internal static let placeholder = Strings.tr("Localizable", "task.form.title.placeholder", fallback: "Title")
      }
    }
    internal enum Section {
      /// Completed
      internal static let completed = Strings.tr("Localizable", "task.section.completed", fallback: "Completed")
      /// Due
      internal static let due = Strings.tr("Localizable", "task.section.due", fallback: "Due")
      /// Due Date
      internal static let dueDate = Strings.tr("Localizable", "task.section.due_date", fallback: "Due Date")
      /// Pending
      internal static let pending = Strings.tr("Localizable", "task.section.pending", fallback: "Pending")
      /// Priority
      internal static let priority = Strings.tr("Localizable", "task.section.priority", fallback: "Priority")
      /// Task Details
      internal static let taskDetails = Strings.tr("Localizable", "task.section.task_details", fallback: "Task Details")
    }
    internal enum Validation {
      /// Title must be at least 3 characters
      internal static let titleMinLength = Strings.tr("Localizable", "task.validation.title_min_length", fallback: "Title must be at least 3 characters")
      /// Title is required
      internal static let titleRequired = Strings.tr("Localizable", "task.validation.title_required", fallback: "Title is required")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
