//
//  TaskDetailModel.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 09/11/24.
//

import Foundation

class TaskDetailViewModel {
    
    // MARK: - Properties
    private var task: Task
    
    var title: String {
        return task.title
    }
    
    var description: String {
        return task.description ?? ""
    }
    
    var dueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: task.dueDate)
    }
    
    var priority: String {
        switch task.priority {
        case .high:
            return "High"
        case .medium:
            return "Medium"
        case .low:
            return "Low"
        }
    }
    
    // MARK: - Initializer
    init(task: Task) {
        self.task = task
    }
    
    // MARK: - Methods
    func markAsCompleted() {
        task.isCompleted = true
        // Save the updated task state to persistent storage if needed
    }
}

