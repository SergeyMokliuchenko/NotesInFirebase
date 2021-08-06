//
//  NotePresenter.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 06.08.2021.
//

import UIKit

protocol NoteViewProtocol: AnyObject {
    
    func updateText(note: String)
    func loadImage(from url: String?)
    func updateImage(image: UIImage)
    func save()
    func saved()
}

protocol NotePresenterProtocol: AnyObject {
    
    var view: NoteViewProtocol { get }
    var model: NoteProtocol? { get set }
    var dataProvider: DataProvider? { get }
    
    init(view: NoteViewProtocol, model: NoteProtocol)
    
    func setupNote()
    func setImage(image: UIImage, name: String)
    func saveNote(text: String)
}

extension NotePresenterProtocol {
    
    var dataProvider: DataProvider? {
        return FirebaseDataProvider()
    }
}

class NotePresenter: NotePresenterProtocol {
    
    var view: NoteViewProtocol
    var model: NoteProtocol?
    
    required init(view: NoteViewProtocol, model: NoteProtocol) {
        self.view = view
        self.model = model
    }
    
    func setupNote() {
        guard let note = model else { return }
        view.updateText(note: note.title)
        view.loadImage(from: note.imageUrl)
    }
    
    func saveNote(text: String) {
        view.save()
        model?.reference?.removeValue()
        model = NoteModel(title: text, imageName: model?.imageName,
                          imageUrl: model?.imageUrl, image: model?.image, date: currentDate())
        guard let note = model else { return }
        dataProvider?.saveNote(model: note)
        view.saved()
    }
    
    func setImage(image: UIImage, name: String) {
        model?.imageName = name
        model?.image = image
        view.updateImage(image: image)
    }
    
    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return dateFormatter.string(from: Date())
    }
}
