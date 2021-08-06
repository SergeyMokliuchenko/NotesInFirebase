//
//  NoteModel.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 03.08.2021.
//

import Foundation
import Firebase

protocol NoteProtocol {
    
    var title: String { get set }
    var imageName: String? { get set }
    var imageUrl: String? { get }
    var image: UIImage? { get set }
    var date: String { get set }
    var reference: DatabaseReference? { get }
    
    init(title: String, imageName: String?, imageUrl: String?, image: UIImage?, date: String)
    init(snapshot: DataSnapshot)
}

struct NoteModel: NoteProtocol {
    
    var title: String
    var imageName: String?
    var imageUrl: String?
    var image: UIImage?
    var date: String
    var reference: DatabaseReference?
    
    init(title: String, imageName: String?, imageUrl: String?, image: UIImage?, date: String) {
        self.title = title
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.image = image
        self.date = date
        self.reference = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.title = snapshotValue["title"] as! String
        self.imageName = snapshotValue["imageName"] as? String
        self.imageUrl = snapshotValue["imageUrl"] as? String
        self.date = snapshotValue["date"] as! String
        self.reference = snapshot.ref
    }
}
