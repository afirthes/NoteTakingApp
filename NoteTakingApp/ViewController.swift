//
//  ViewController.swift
//  NoteTakingApp
//
//  Created by Afir Thes on 14.12.2022.
//

import UIKit

class ViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notes = [Note]()
    private var notesModel = NotesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        notesModel.delegate = self
        
        notesModel.getNotes()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let noteViewController = segue.destination as! NoteViewController
        
        if tableView.indexPathForSelectedRow != nil {
            noteViewController.note = notes[tableView.indexPathForSelectedRow!.row]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
        
        noteViewController.notesModel = self.notesModel
        
        
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let titleLabel = cell.viewWithTag(1) as? UILabel
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        
        let note = notes[indexPath.row]
        
        titleLabel?.text = note.title
        bodyLabel?.text = note.body
        
        return cell
    }
}

extension ViewController: NotesModelProtocol {
    
    func notesRetrieved(notes: [Note]) {
        self.notes = notes
        
        tableView.reloadData()
    }

}
