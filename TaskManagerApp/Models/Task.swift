//
//  Task.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 07/11/24.
//

import Foundation

struct Task: Codable {
    var id: String
    var title: String
    var description: String?
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool = false

    enum Priority: String, Codable {
        case low, medium, high
    }
}

