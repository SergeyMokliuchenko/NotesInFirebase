//
//  NotesListPresenter.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 05.08.2021.
//

import Foundation

protocol NotesListViewProtocol: AnyObject {
    func loading()
    func loaded()
    func error(message: String)
}

protocol NotesListPresenterProtocol: AnyObject {
    
    var view: NotesListViewProtocol { get }
    var model: [NoteProtocol] { get }
    var dataProvider: DataProvider? { get }
    
    init(view: NotesListViewProtocol, model: [NoteProtocol])
    
    func getNotes()
    func removeFirebaseObserver()
    func getNotesCount() -> Int
    func getNoteModel(for indexPath: IndexPath) -> NoteProtocol
    func logout()
    func removeNote(for indexPath: IndexPath)
}

extension NotesListPresenterProtocol {
    
    var dataProvider: DataProvider? {
        return FirebaseDataProvider()
    }
}

class NotesListPresenter: NotesListPresenterProtocol {
    
    var view: NotesListViewProtocol
    var model: [NoteProtocol]
    
    required init(view: NotesListViewProtocol, model: [NoteProtocol]) {
        self.view = view
        self.model = model
    }
    
    func getNotes() {
        view.loading()
        dataProvider?.loadNotes() { [weak self] notes in
            self?.model = notes
            self?.view.loaded()
        }
    }
    
    func getNotesCount() -> Int {
        return model.count
    }
    
    func getNoteModel(for indexPath: IndexPath) -> NoteProtocol {
        return model[indexPath.row]
    }
    
    func removeFirebaseObserver() {
        dataProvider?.removeObservers()
    }
    
    func logout() {
        view.loading()
        dataProvider?.logout() { [weak self] status in
            self?.view.loaded()
            switch status.authResult() {
            case .statusOK:
                SceneDelegate.shared.rootViewController.unauthorized()
            case .statusFail:
                self?.view.error(message: status.authError())
            }
        }
    }
    
    func removeNote(for indexPath: IndexPath) {
        let note = model[indexPath.row]
        dataProvider?.deleteNote(model: note)
        model.remove(at: indexPath.row)
    }
}
