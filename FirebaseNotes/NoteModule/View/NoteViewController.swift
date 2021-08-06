//
//  NoteViewController.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 03.08.2021.
//

import UIKit
import Photos

class NoteViewController: BaseViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var noteImageView: UIImageView!
    
    var presenter: NotePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self,
                                        action: #selector(addImage))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self,
                                         action: #selector(saveNote))
        navigationItem.rightBarButtonItems = [addButton, saveButton]
    }
    
    @objc private func addImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    @objc private func saveNote() {
        if let note = noteTextView.text {
            presenter.saveNote(text: note)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setupNote()
    }
}

// MARK: - NoteViewProtocol
extension NoteViewController: NoteViewProtocol {
    
    func updateText(note: String) {
        noteTextView.text = note
    }
    
    func loadImage(from url: String?) {
        noteImageView.downloadImage(from: url)
    }
    
    func updateImage(image: UIImage) {
        noteImageView.image = image
    }
    
    func save() {
        showActivityView(on: view)
    }
    
    func saved() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension NoteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension NoteViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage, let url = info[.imageURL] as? URL {
            let name = url.lastPathComponent
            presenter.setImage(image: editedImage, name: name)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension NoteViewController: UINavigationControllerDelegate { }
