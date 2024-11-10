//
//  AddTaskViewController.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 09/11/24.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var completeSwitch: UISwitch!
    
    // Callback to pass the new task back
    var onTaskAdded: ((Task) -> Void)?
    var onTaskUpdated: ((Task) -> Void)?
    var onTaskDeleted: ((Task) -> Void)?
    private var viewModel: TaskViewModel
    var task: Task?
    var updateFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
        setupData()
    }
    
    // Initializer
    init(viewModel: TaskViewModel, task: Task? = nil) {
        self.viewModel = viewModel
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        // Initialize with a default TaskViewModel (or any default value)
        self.viewModel = TaskViewModel()  // Or get it from somewhere
        self.task = nil  // You can also pass an existing task if necessary
        super.init(coder: coder)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Add Task"
        if updateFlag {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewTask))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
        }
        completeSwitch.isOn = task?.isCompleted ?? false
        // Customize due date picker (optional)
        if let dueDatePicker = dueDatePicker {
               dueDatePicker.minimumDate = Date()
        } else {
               print("dueDatePicker is nil")
        }
    }
    
    private func setupData() {
        guard let task = task else { return }
        titleTextField.text = task.title
        descriptionTextField.text = task.description
        dueDatePicker.date = task.dueDate
        prioritySegmentedControl.selectedSegmentIndex = task.priority == .low ? 0 : task.priority == .medium ? 1 : 2
        completeSwitch.isOn = task.isCompleted
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Save Task
    @objc private func saveTask() {
        // Validate inputs
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        // Get due date and priority
        let dueDate = dueDatePicker.date
        let priority: Task.Priority = {
            switch prioritySegmentedControl.selectedSegmentIndex {
            case 0: return .low
            case 1: return .medium
            default: return .high
            }
        }()
        
        // Create a new Task instance
        let newTask = Task(id: UUID().uuidString, title: title, description: description, dueDate: dueDate, priority: priority, isCompleted: true)
        
        // Pass the task back using the callback
        onTaskAdded?(newTask)
        
        // Dismiss or pop the view controller
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func saveNewTask() {
        let priority: Task.Priority = {
            switch prioritySegmentedControl.selectedSegmentIndex {
            case 0: return .low
            case 1: return .medium
            default: return .high
            }
        }()
        
        // Create a new task or update the existing task
        let newTask = Task(
            id: task?.id ?? UUID().uuidString,
            title: titleTextField.text ?? "Untitled",
            description: descriptionTextField.text,
            dueDate: dueDatePicker.date,
            priority: priority,
            isCompleted: completeSwitch.isOn
        )
        
        if let existingTask = task {
            viewModel.updateTask(newTask) {
                self.onTaskUpdated?(newTask) // Trigger the update closure
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            viewModel.addTask(newTask) {
                self.onTaskUpdated?(newTask)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func deleteTask() {
        guard let task = task else { return }
        viewModel.deleteTask(task.id) {
            self.onTaskDeleted?(task)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

