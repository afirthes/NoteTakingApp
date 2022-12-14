//
//  NoteViewController.swift
//  NoteTakingApp
//
//  Created by Afir Thes on 14.12.2022.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var starButton: UIButton!
    
    var note:Note?
    var notesModel:NotesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if note != nil {
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
            setStarButton()
        } else {
            self.note = Note(docId: UUID().uuidString,
                         title: titleTextField.text ?? "",
                         body: bodyTextView.text ?? "",
                         isStarred: false,
                         createdAt: Date(),
                         lastUpdatedAt: Date())
        }
    }
    
    func setStarButton() {
        let imageName = note!.isStarred ? "star.fill" : "star"
        starButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        titleTextField.text = ""
        bodyTextView.text = ""
        self.note = nil
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        guard let note = self.note else { return }
        notesModel?.deleteNote(note)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
         
        // old note
        self.note!.title = titleTextField.text ?? ""
        self.note!.body = bodyTextView.text ?? ""
        self.note!.lastUpdatedAt = Date()
        
        self.notesModel?.saveNote(self.note!)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func starTappe(_ sender: Any) {
        if note != nil, notesModel != nil  {
            self.note!.isStarred.toggle()
            setStarButton()
            notesModel!.updateStarredStatus(note!.docId, note!.isStarred)
        }
    }
}
