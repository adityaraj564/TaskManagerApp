//
//  TaskViewModel.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 07/11/24.
//

import Foundation

class TaskViewModel {
    private var taskService = TaskService()
    var tasks: [Task] = []

    func fetchTasks(completion: @escaping () -> Void) {
        taskService.fetchTasks { [weak self] tasks in
            self?.tasks = tasks
            completion()
        }
    }

    func addTask(_ task: Task, completion: @escaping () -> Void) {
        taskService.addTask(task) { [weak self] success in
            if success {
                self?.tasks.append(task)  // Directly append task
                print("Task added successfully to Firebase")
                completion()
            } else {
                print("Error: Task not added")
            }
        }
    }

    func deleteTask(_ taskId: String, completion: @escaping () -> Void) {
        taskService.deleteTask(taskId) { success in
            print("Delete callback reached, success: \(success)")
            if success {
                print("Task deleted successfully")
                completion()
            } else {
                print("Failed to delete task.")
            }
        }
        completion()
    }

    func updateTask(_ task: Task, completion: @escaping () -> Void) {
        taskService.updateTask(task) { [weak self] success in
            if success { self?.fetchTasks(completion: completion) }
        }
        if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
             // Update the task in the local array
             self.tasks[index] = task
         }
    }
}

