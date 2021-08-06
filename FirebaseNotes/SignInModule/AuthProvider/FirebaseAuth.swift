//
//  FirebaseAuth.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 05.08.2021.
//

import Foundation
import Firebase

protocol AuthProvider {
    
    func signIn(credentials: AuthCredentials, completion: @escaping (AuthHundler) -> Void)
    func signUp(credentials: AuthCredentials, completion: @escaping (AuthHundler) -> Void)
}

class FirebaseAuth: AuthProvider {
    
    func signIn(credentials: AuthCredentials, completion: @escaping (AuthHundler) -> Void) {
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { _, error in
            let authHundler = AuthHundler(error: error)
            completion(authHundler)
        }
    }
    
    func signUp(credentials: AuthCredentials, completion: @escaping (AuthHundler) -> Void) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { authResult, error in
            
            let authHundler = AuthHundler(error: error)
            completion(authHundler)
            
            if let authResult = authResult {
                Database.database().reference(withPath: "Users").child(authResult.user.uid).setValue(["email": authResult.user.email])
            }
        }
    }
}
