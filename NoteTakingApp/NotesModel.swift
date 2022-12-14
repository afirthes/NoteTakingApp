//
//  Model.swift
//  NoteTakingApp
//
//  Created by Afir Thes on 14.12.2022.
//

import Foundation
import Firebase


protocol NotesModelProtocol {
    func notesRetrieved(notes: [Note])
}

class NotesModel {
    
    var delegate: NotesModelProtocol?
    
    func getNotes() {
        
        let db = Firestore.firestore()
        db.collection("notes").getDocuments { querySnapshot, error in
            if error == nil && querySnapshot != nil {
                var notes = [Note]()
                
                for doc in querySnapshot!.documents {
                    
                    let createdAtDate:Date = Timestamp.dateValue( doc["createdAt"] as! Timestamp )()
                    let lastUpdatedAtDate:Date = Timestamp.dateValue( doc["lastUpdatedAt"] as! Timestamp )()
                    
                    let n = Note(docId: doc["docId"] as! String,
                                 title: doc["title"] as! String,
                                 body: doc["body"] as! String,
                                 isStarred: doc["isStarred"] as! Bool,
                                 createdAt: createdAtDate,
                                 lastUpdatedAt: lastUpdatedAtDate)
                    
                    notes.append(n)
                
                }
                
                DispatchQueue.main.async {
                    self.delegate?.notesRetrieved(notes: notes)
                }
                
            }
        }
    }
    
    func deleteNote(_ n: Note) {
        let db = Firestore.firestore()
        
        db.collection("notes").document(n.docId).delete()
    }
    
    func saveNote(_ n: Note) {
        let db = Firestore.firestore()
        
        db.collection("notes").document(n.docId).setData(noteToDict(n))
    }
    
    func noteToDict(_ n: Note) -> [String:Any] {
        var dict = [String:Any]()
        
        dict["docId"] = n.docId
        dict["title"] = n.title
        dict["body"] = n.body
        dict["createdAt"] = n.createdAt
        dict["lastUpdatedAt"] = n.lastUpdatedAt
        dict["isStarred"] = n.isStarred
        
        return dict
    }
}
