import Foundation

enum TaskPriority: String, CaseIterable, Identifiable {
    case none = "None"
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var id: String { rawValue }
} 