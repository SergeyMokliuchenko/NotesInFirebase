//
//  FirebaseDataProvider.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 06.08.2021.
//

import Foundation
import Firebase
import FirebaseStorage

protocol DataProvider {
    
    func logout(completion: @escaping(AuthHundler) -> Void)
    func loadNotes(completion: @escaping([NoteProtocol]) -> Void)
    func saveNote(model: NoteProtocol)
    func deleteNote(model: NoteProtocol)
    func removeObservers()
}

class FirebaseDataProvider: DataProvider {
    
    private let database = Database.database().reference(withPath: "Users")
    private var storage = Storage.storage().reference().child("Users")
    private let currentUser = Auth.auth().currentUser
    
    func logout(completion: @escaping(AuthHundler) -> Void) {
        do {
            try Auth.auth().signOut()
            let authHundler = AuthHundler(error: nil)
            completion(authHundler)
        } catch let error {
            let authHundler = AuthHundler(error: error)
            completion(authHundler)
        }
    }
    
    func loadNotes(completion: @escaping([NoteProtocol]) -> Void) {
        guard let user = currentUser else { return }
        database.child(user.uid).child("Notes").observe(.value) { snapshot in
            var notes: [NoteModel] = []
            for item in snapshot.children {
                if let snapshot = item as? DataSnapshot {
                    let note = NoteModel(snapshot: snapshot)
                    notes.append(note)
                }
            }
            completion(notes)
        }
    }
    
    func saveNote(model: NoteProtocol) {
        guard let user = currentUser else { return }
        
        let noteReferense = database.child(user.uid).child("Notes").childByAutoId()
        noteReferense.setValue(["title": model.title,
                                "imageName": model.imageName as Any,
                                "imageUrl": model.imageUrl as Any,
                                "date": model.date])
        
        saveImage(model: model) { imageUrl in
            noteReferense.updateChildValues(["imageUrl": imageUrl])
        }
    }
    
    private func saveImage(model: NoteProtocol, completion: @escaping(String) -> Void) {
        guard
            let user = currentUser,
            let imageName = model.imageName,
            let image = model.image,
            let imageData = image.jpegData(compressionQuality: 1)
        else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageReference = storage.child(user.uid).child("Images").child(imageName)
        
        imageReference.putData(imageData, metadata: metaData) { metadata, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            imageReference.downloadURL { url, error in
                guard let stringUrl = url?.absoluteString else { return }
                completion(stringUrl)
            }
        }
    }
    
    func deleteNote(model: NoteProtocol) {
        guard let user = currentUser, let imageName = model.imageName else { return }
        model.reference?.removeValue()
        let imageReference = storage.child(user.uid).child("Images").child(imageName)
        imageReference.delete { error in
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeObservers() {
        guard let user = currentUser else { return }
        let noteReferense = database.child(user.uid).child("Notes")
        noteReferense.removeAllObservers()
    }
}
