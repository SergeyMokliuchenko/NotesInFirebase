//
//  SignInPresenter.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 05.08.2021.
//

import Foundation

protocol AuthViewProtocol: AnyObject {
    
    func loading()
    func loaded()
    func authError(error: String)
}

protocol AuthViewPresenterProtocol: AnyObject {
    
    var view: AuthViewProtocol { get }
    var credentials: AuthCredentials { get set }
    var authProvider: AuthProvider? { get }
    
    init(view: AuthViewProtocol, model: AuthCredentials)
    
    func auth()
}

extension AuthViewPresenterProtocol {
    
    var authProvider: AuthProvider? {
        return FirebaseAuth()
    }
}

class SignInPresenter: AuthViewPresenterProtocol {
    
    var view: AuthViewProtocol
    var credentials: AuthCredentials
    
    required init(view: AuthViewProtocol, model: AuthCredentials) {
        self.view = view
        self.credentials = model
    }
    
    func auth() {
        view.loading()
        authProvider?.signIn(credentials: credentials) { [weak self] status in
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
