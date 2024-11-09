//
//  AuthViewModel.swift
//  TaskManagerApp
//
//  Created by Aditya Raj on 07/11/24.
//

import Foundation

class AuthViewModel {
    private let authService = AuthService()
    
    // Callbacks to notify the view controller of authentication status
    var onAuthSuccess: (() -> Void)?
    var onAuthFailure: ((String) -> Void)?

    func login(email: String, password: String) -> String {
        var errorMessage = ""
        authService.signIn(email: email, password: password) { [weak self] success, error in
            if success {
                print("Successfully Loggedin")
                self?.onAuthSuccess?()
            } else {
                errorMessage = error?.localizedDescription ?? ""
                self?.onAuthFailure?("Login failed. Please check your email and password.")
            }
        }
        return errorMessage
    }

    func signup(email: String, password: String) -> String {
        var errorMessage = ""
        authService.signUp(email: email, password: password) { [weak self] success, error in
            if success {
                print("Successfully Signedin")
                self?.onAuthSuccess?()
            } else {
                errorMessage = error?.localizedDescription ?? ""
                print("Signup Error: \(errorMessage)")
                self?.onAuthFailure?("Signup failed. Please try again.")
            }
        }
        return errorMessage
    }

    func signOut(completion: @escaping (Bool) -> Void) {
        authService.signOut { success in
            completion(success)
        }
    }
}

