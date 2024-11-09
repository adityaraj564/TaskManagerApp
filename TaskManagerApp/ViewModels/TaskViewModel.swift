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
            if success { self?.fetchTasks(completion: completion) }
        }
    }

    func deleteTask(_ taskId: String, completion: @escaping () -> Void) {
        taskService.deleteTask(taskId) { [weak self] success in
            if success { self?.fetchTasks(completion: completion) }
        }
    }

    func updateTask(_ task: Task, completion: @escaping () -> Void) {
        taskService.updateTask(task) { [weak self] success in
            if success { self?.fetchTasks(completion: completion) }
        }
    }
}

