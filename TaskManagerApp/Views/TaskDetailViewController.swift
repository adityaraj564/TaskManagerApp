//
//  TaskDetailViewController.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 07/11/24.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    private var viewModel: TaskViewModel
    private var task: Task?
    
    // UI Elements
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let dueDatePicker = UIDatePicker()
    private let prioritySegmentedControl = UISegmentedControl(items: ["Low", "Medium", "High"])
    private let completeSwitch = UISwitch()
    private let saveButton = UIButton(type: .system)
    
    // Initializer
    init(viewModel: TaskViewModel, task: Task? = nil) {
        self.viewModel = viewModel
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = task == nil ? "New Task" : "Edit Task"
        
        // Setup UI components with layout and styling
        titleTextField.placeholder = "Title"
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8
        dueDatePicker.datePickerMode = .date
        completeSwitch.isOn = task?.isCompleted ?? false
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        
        // Layout UI elements
        let stackView = UIStackView(arrangedSubviews: [
            titleTextField,
            descriptionTextView,
            dueDatePicker,
            prioritySegmentedControl,
            completeSwitch,
            saveButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupData() {
        guard let task = task else { return }
        titleTextField.text = task.title
        descriptionTextView.text = task.description
        dueDatePicker.date = task.dueDate
        prioritySegmentedControl.selectedSegmentIndex = task.priority == .low ? 0 : task.priority == .medium ? 1 : 2
        completeSwitch.isOn = task.isCompleted
    }
    
    @objc private func saveTask() {
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
            description: descriptionTextView.text,
            dueDate: dueDatePicker.date,
            priority: priority,
            isCompleted: completeSwitch.isOn
        )
        
        if task == nil {
            viewModel.addTask(newTask) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            viewModel.updateTask(newTask) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

