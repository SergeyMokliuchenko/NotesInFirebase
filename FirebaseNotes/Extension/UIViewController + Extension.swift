//
//  UIViewController + Extension.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 05.08.2021.
//

import UIKit

extension UIViewController {
    
    func showErrorAlertController(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default) { _ in self.dismiss(animated: true) }
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func showLogoutAlertController(completion: @escaping () -> Void) {
        
        let title = NSLocalizedString("logout", comment: "")
        let message = NSLocalizedString("question_1", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let leftButton = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default) { _ in completion() }
        let rightButton = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .default)
        
        alertController.addAction(leftButton)
        alertController.addAction(rightButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDeleteAlertController(completion: @escaping () -> Void) {
        
        let title = NSLocalizedString("delete", comment: "")
        let message = NSLocalizedString("question_2", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let leftButton = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default) { _ in completion() }
        let rightButton = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .default)
        
        alertController.addAction(leftButton)
        alertController.addAction(rightButton)
        
        present(alertController, animated: true, completion: nil)
    }
}
