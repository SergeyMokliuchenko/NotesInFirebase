//
//  LaunchViewController.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 03.08.2021.
//

import UIKit
import Firebase

class LaunchViewController: BaseViewController {

    private var auth: Auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityView(on: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        auth.addStateDidChangeListener { auth, user in
            switch user {
            case .none:
                SceneDelegate.shared.rootViewController.unauthorized()
            case .some(_):
                SceneDelegate.shared.rootViewController.authorized()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(auth)
    }
}
