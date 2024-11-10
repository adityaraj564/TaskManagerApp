//
//  TaskService.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 07/11/24.
//

import Foundation
import FirebaseFirestore

class TaskService {
    private let db = Firestore.firestore()
    
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        db.collection("tasks").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else { return }
            let tasks = documents.compactMap { try? $0.data(as: Task.self) }
            completion(tasks)
        }
    }

    func addTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("tasks").document(task.id).setData(from: task)
            completion(true)
        } catch {
            completion(false)
        }
    }

    func deleteTask(_ taskId: String, completion: @escaping (Bool) -> Void) {
        db.collection("tasks").document(taskId).delete { error in
            if error == nil {
                completion(true)
            } else {
                print("Deletion Failed to firebase \(error)")
            }
        }
    }

    func updateTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("tasks").document(task.id).setData(from: task)
            completion(true)
        } catch {
            completion(false)
        }
    }
}

