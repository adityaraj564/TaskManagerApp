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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
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
    
    
    @objc private func saveTask() {
        guard let newTask = buildTask() else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        if let existingTask = task {
            viewModel.updateTask(newTask) {
                self.onTaskUpdated?(newTask)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            viewModel.addTask(newTask) {
                self.onTaskAdded?(newTask)
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
    
    // MARK: - Helper Functions
    private func buildTask() -> Task? {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else { return nil }
        
        let priority: Task.Priority = {
                   switch prioritySegmentedControl.selectedSegmentIndex {
                   case 0: return .low
                   case 1: return .medium
                   default: return .high
                   }
               }()
        let newTask = Task(
            id: task?.id ?? UUID().uuidString,
            title: title,
            description: description,
            dueDate: dueDatePicker.date,
            priority: priority,
            isCompleted: completeSwitch.isOn
        )
        
        return newTask
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

