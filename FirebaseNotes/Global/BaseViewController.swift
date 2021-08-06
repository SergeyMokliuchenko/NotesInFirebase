//
//  BaseViewController.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 03.08.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var activityView: UIView?
    
    func showActivityView(on view : UIView?) {
        
        guard let view = view else { return }
        
        let activityView = UIView(frame: UIScreen.main.bounds)
        activityView.backgroundColor = .clear
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1058823529, alpha: 0.75)
        activityIndicator.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.startAnimating()
        activityIndicator.center = activityView.center
        
        DispatchQueue.main.async {
            activityView.addSubview(activityIndicator)
            view.addSubview(activityView)
        }
        
        self.activityView = activityView
    }
    
    func removeActivityView() {
        DispatchQueue.main.async {
            self.activityView?.removeFromSuperview()
            self.activityView = nil
        }
    }
}
