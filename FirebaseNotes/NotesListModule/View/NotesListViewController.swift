//
//  NotesListViewController.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 02.08.2021.
//

import UIKit

class NotesListViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var notesTableView: UITableView!
    
    var presenter: NotesListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotesTableView()
        configureNavigationBar()
    }
    
    private func configureNotesTableView() {
        notesTableView.dataSource = self
        notesTableView.delegate = self
        notesTableView.register(UINib(nibName: String(describing: NoteTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NoteTableViewCell.self))
    }
    
    private func configureNavigationBar() {
        navigationItem.title = NSLocalizedString("notes", comment: "")
        let exitButton = UIBarButtonItem(title: NSLocalizedString("logout", comment: ""), style: .plain, target: self, action: #selector(logoutButtonAction))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNoteButtonAction))
        navigationItem.leftBarButtonItem = exitButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func logoutButtonAction() {
        showLogoutAlertController { [weak self] in
            self?.presenter.logout()
        }
    }
    
    @objc private func newNoteButtonAction() {
        let model = NoteModel(title: "", imageName: "", imageUrl: nil, image: nil, date: "")
        pushNoteViewController(note: model)
    }
    
    private func pushNoteViewController(note: NoteProtocol) {
        let view = NoteViewController()
        let presenter = NotePresenter(view: view, model: note)
        view.presenter = presenter
        navigationController?.pushViewController(view, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getNotes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.removeFirebaseObserver()
    }
}

// MARK: - NotesListViewProtocol
extension NotesListViewController: NotesListViewProtocol {
    
    func loading() {
        showActivityView(on: view)
        notesTableView.isHidden = true
    }
    
    func loaded() {
        notesTableView.reloadData()
        removeActivityView()
        notesTableView.isHidden = false
    }
    
    func error(message: String) {
        showErrorAlertController(message: message)
    }
}

// MARK: - UITableViewDataSource
extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNotesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteTableViewCell.self)) as? NoteTableViewCell else { return UITableViewCell() }
        let note = presenter.getNoteModel(for: indexPath)
        cell.updateCell(model: note)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushNoteViewController(note: presenter.getNoteModel(for: indexPath))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteAlertController { [weak self] in
                self?.presenter.removeNote(for: indexPath)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
