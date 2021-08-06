//
//  NoteTableViewCell.swift
//  FirebaseNotes
//
//  Created by Serhii Mokliuchenko on 03.08.2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    
    func updateCell(model: NoteProtocol) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        noteImageView.downloadImage(from: model.imageUrl)
    }
}
