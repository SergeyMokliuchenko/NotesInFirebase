//
//  SignInViewController.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 03.08.2021.
//

import UIKit

class SignInViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var presenter: AuthViewPresenterProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalizedNames()
    }
    
    private func setLocalizedNames() {
        navigationItem.title = NSLocalizedString("authorization", comment: "")
        emailTextField.placeholder = NSLocalizedString("email_address", comment: "")
        passwordTextField.placeholder = NSLocalizedString("password", comment: "")
        signInButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        signUpButton.setTitle(NSLocalizedString("create_account", comment: ""), for: .normal)
    }
    
    // MARK: - IBAction
    @IBAction func signInButtonAction(_ sender: UIButton) {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        let credentials = SignInCredentials(email: email, password: password)
        
        presenter.credentials = credentials
        presenter.auth()
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        let model = SignUpCredentials(email: "", password: "", confirmPassword: "")
        let view = SignUpViewController()
        let presenter = SignUpPresenter(view: view, model: model)
        view.presenter = presenter
        navigationController?.pushViewController(view, animated: true)
    }
}

// MARK: - AuthViewProtocol
extension SignInViewController: AuthViewProtocol {
    
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
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
