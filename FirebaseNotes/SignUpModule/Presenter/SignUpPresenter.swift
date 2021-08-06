//
//  SignUpPresenter.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 05.08.2021.
//

import Foundation

class SignUpPresenter: AuthViewPresenterProtocol {
    
    var view: AuthViewProtocol
    var credentials: AuthCredentials
    
    required init(view: AuthViewProtocol, model: AuthCredentials) {
        self.view = view
        self.credentials = model
    }
    
    func auth() {
        view.loading()
        
        if credentials.password != credentials.confirmPassword {
            view.authError(error: "Password do not math.")
            view.loaded()
            return
        }
        
        authProvider?.signUp(credentials: credentials) { [weak self] status in
            self?.view.loaded()
            switch status.authResult() {
            case .statusOK:
                SceneDelegate.shared.rootViewController.authorized()
            case .statusFail:
                self?.view.authError(error: status.authError())
            }
        }
    }
}
