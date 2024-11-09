//
//  LoginViewController.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 07/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel = AuthViewModel()
    
    // UI Elements
    @IBOutlet weak var loginMainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        loginMainView.layer.cornerRadius = 20
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        loginButton.titleLabel?.text = "Login"
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        signupButton.titleLabel?.text = "Sign Up"
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

    }
    
    private func setupBindings() {
        // Bind the ViewModel callbacks to update the UI
        viewModel.onAuthSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToTaskListScreen()
            }
        }
        
        viewModel.onAuthFailure = { [weak self] errorMessage in
            // Display the error message in the errorLabel
            self?.errorLabel.text = errorMessage
        }
    }

    @objc private func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter both email and password."
            return
        }
        
        let errorMsg = viewModel.login(email: email, password: password)
        if !errorMsg.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = errorMsg
        } else {
            
        }
    }
    
    @objc private func signupTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter both email and password."
            return
        }
        
        let errorMsg = viewModel.signup(email: email, password: password)
        errorLabel.isHidden = false
        errorLabel.text = errorMsg
    }
    
    private func navigateToTaskListScreen() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let taskListVC = storyboard.instantiateViewController(withIdentifier: "TaskListView") as? TaskListViewController else {
                return
            }
            
            // Push or present the Task List screen
            self.navigationController?.pushViewController(taskListVC, animated: true)
        }
}


