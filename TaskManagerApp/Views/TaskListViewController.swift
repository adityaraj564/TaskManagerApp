//
//  TaskListViewController.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 07/11/24.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let viewModel = TaskViewModel()
    private var tasks: [Task] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task List"
        setupTableView()
        fetchTasks()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func fetchTasks() {
        viewModel.fetchTasks {
            self.tasks = self.viewModel.tasks
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func navigateToTaskDetailsScreen(with task: Task) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let taskDetailVC = storyboard.instantiateViewController(withIdentifier: "TaskDetail") as? TaskDetailViewController else {
                return
            }
            
            // Pass the selected task to TaskDetailViewController
          //  taskDetailVC.viewModel = TaskDetailViewModel(task: task)
            
            // Push the Task Detail screen
            self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = /*task.title ??*/ "Aditya"
        cell.accessoryType = /*task.isCompleted ? .checkmark : .none*/ .checkmark
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to TaskDetailViewController to view/edit the task
        tableView.deselectRow(at: indexPath, animated: true)
                
                // Get the selected task and navigate to TaskDetailViewController
        let selectedTask = tasks[indexPath.row]
        navigateToTaskDetailsScreen(with: selectedTask)
    }
}

