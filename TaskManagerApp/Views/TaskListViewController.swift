//
//  TaskListViewController.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 07/11/24.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionList: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var priorityLbl: UILabel!
}

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let viewModel = TaskViewModel()
    private var tasks: [Task] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task List"
        setupTableView()
        fetchTasks()
        // Add a button in the navigation bar for adding tasks
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
    }
    

    @objc private func addTaskTapped() {
        // Navigate to a task creation screen or present an alert
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addTaskVC = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController {
            
            // Provide the onTaskAdded closure
            addTaskVC.onTaskAdded = { newTask in
                // Add the new task to the tasks array
                self.tasks.append(newTask)
                
                // Reload the table view to display the new task
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            navigationController?.pushViewController(addTaskVC, animated: true)
        }
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
        guard let taskDetailVC = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController else {
            print("Failed to instantiate TaskDetailViewController with identifier 'TaskDetail'")
            return
        }
        
        taskDetailVC.task = task
        taskDetailVC.onTaskUpdated = { updatedTask in
            if let index = self.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                self.tasks[index] = updatedTask // Update the task in the array
                print("Data updated")
                DispatchQueue.main.async {
                    self.tableView.reloadData() // Refresh table view
                }
            }
        }
        
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        // Configure the cell with the task data
        cell.titleLbl.text = task.title
        cell.descriptionList.text = task.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        cell.dueDateLbl.text = dateFormatter.string(from: task.dueDate)
        
        // Set the priority label (adjust if necessary)
        cell.priorityLbl.text = String(describing: task.priority)
        
        // Set the accessory type based on completion status
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to TaskDetailViewController to view/edit the task
        tableView.deselectRow(at: indexPath, animated: true)
                
                // Get the selected task and navigate to TaskDetailViewController
        let selectedTask = tasks[indexPath.row]
        navigateToTaskDetailsScreen(with: selectedTask)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Get the task to delete
            let taskToDelete = tasks[indexPath.row]
            
            // Call the delete function from the view model
            viewModel.deleteTask(taskToDelete.id) {
                // Remove the task from the local array
                self.tasks.remove(at: indexPath.row)
                
                // Delete the row from the table view with animation
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

