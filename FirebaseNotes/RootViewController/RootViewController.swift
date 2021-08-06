//
//  RootViewController.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 03.08.2021.
//

import UIKit

class RootViewController: UIViewController {
    
    private var currentViewController: UIViewController
    
    init() {
        self.currentViewController = LaunchViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(currentViewController)
        currentViewController.view.frame = view.bounds
        view.addSubview(currentViewController.view)
        currentViewController.didMove(toParent: self)
    }
    
    func unauthorized() {
        let model = SignInCredentials(email: "", password: "")
        let view = SignInViewController()
        let presenter = SignInPresenter(view: view, model: model)
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        animateTransition(to: navigationController)
    }
    
    func authorized() {
        let view = NotesListViewController()
        let presenter = NotesListPresenter(view: view, model: [])
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        animateTransition(to: navigationController)
    }
    
    private func animateTransition(to tabBarController: UIViewController) {
        currentViewController.willMove(toParent: nil)
        addChild(tabBarController)
        transition(from: currentViewController, to: tabBarController,
                   duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut]) {
            tabBarController.view.frame = self.view.bounds
        } completion: { [unowned self] compleated in
            self.currentViewController.removeFromParent()
            tabBarController.didMove(toParent: self)
            self.currentViewController = tabBarController
        }
    }
}
