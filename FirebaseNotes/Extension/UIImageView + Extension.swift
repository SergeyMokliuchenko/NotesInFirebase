//
//  UIImageView + Extension.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 06.08.2021.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: String?) {
        
        guard let stringUrl = url, let imageURL = URL(string: stringUrl) else { return }
        
        DispatchQueue.global().async {
            
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
 
