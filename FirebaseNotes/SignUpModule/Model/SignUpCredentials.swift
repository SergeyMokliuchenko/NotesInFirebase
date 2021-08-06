//
//  SignUpCredentials.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 05.08.2021.
//

import Foundation

struct SignUpCredentials: AuthCredentials {
    
    private(set) var email: String
    private(set) var password: String
    private(set) var confirmPassword: String?
    
    init(email: String, password: String, confirmPassword: String) {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
}
