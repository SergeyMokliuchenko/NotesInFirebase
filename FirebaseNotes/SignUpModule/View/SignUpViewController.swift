//
//  SignUpViewController.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 03.08.2021.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var presenter: AuthViewPresenterProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalizedNames()
    }
    
    private func setLocalizedNames() {
        navigationItem.title = NSLocalizedString("registration", comment: "")
        emailTextField.placeholder = NSLocalizedString("email_address", comment: "")
        passwordTextField.placeholder = NSLocalizedString("password", comment: "")
        confirmPasswordTextField.placeholder = NSLocalizedString("confirm_password", comment: "")
        createAccountButton.setTitle(NSLocalizedString("create_account", comment: ""), for: .normal)
    }
    
    // MARK: - IBAction
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text
        else { return }
        
        let credentials = SignUpCredentials(email: email, password: password, confirmPassword: confirmPassword)
        
        presenter.credentials = credentials
        presenter.auth()
    }
}

// MARK: - AuthViewProtocol
extension SignUpViewController: AuthViewProtocol {
    
    func loading() {
        showActivityView(on: view)
    }
    
    func loaded() {
        removeActivityView()
    }
    
    func authError(error: String) {
        showErrorAlertController(message: error)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
