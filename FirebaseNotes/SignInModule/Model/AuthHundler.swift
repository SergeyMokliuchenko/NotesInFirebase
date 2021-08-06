//
//  AuthHundler.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 05.08.2021.
//

import Foundation

class AuthHundler {
    
    private var status: APIAuthStatus = .statusFail
    private var error: Error?
    
    init(error: Error?) {
        switch error {
        case .none:
            self.status = .statusOK
        case .some(let error):
            self.error = error
        }
    }
    
    func authResult() -> APIAuthStatus {
        return status
    }
    
    func authError() -> String {
        return error?.localizedDescription ?? "error"
    }
}
