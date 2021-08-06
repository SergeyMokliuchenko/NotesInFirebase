//
//  SignInCredentials.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 05.08.2021.
//

import Foundation

protocol AuthCredentials {
    
    var email: String { get }
    var password: String { get }
    var confirmPassword: String? { get }
}

struct SignInCredentials: AuthCredentials {
    
    private(set) var email: String
    private(set) var password: String
    private(set) var confirmPassword: String?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.confirmPassword = nil
    }
}
