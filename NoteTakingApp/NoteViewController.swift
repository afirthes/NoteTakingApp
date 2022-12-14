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
    
    var note:Note?
    var notesModel:NotesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if note != nil {
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
        }
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
        guard let note = self.note else {
            // new note
            var n = Note(docId: UUID().uuidString,
                         title: titleTextField.text ?? "",
                         body: bodyTextView.text ?? "",
                         isStarred: false,
                         createdAt: Date(),
                         lastUpdatedAt: Date())
            
            self.note = n
            
            
            return
        }
         
        // old note
        self.note!.title = titleTextField.text ?? ""
        self.note!.body = bodyTextView.text ?? ""
        self.note!.lastUpdatedAt = Date()
        
        self.notesModel?.saveNote(self.note!)
        
        dismiss(animated: true, completion: nil)
    }
    
}
