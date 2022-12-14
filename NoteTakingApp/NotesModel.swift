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
    
    var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func getNotes(_ starredOnly:Bool = false) {
        
        listener?.remove()
        
        let db = Firestore.firestore()
        
        var query:Query = db.collection("notes")
        
        if starredOnly {
            query = query.whereField("isStarred", isEqualTo: true)
        }
        
        self.listener = query.addSnapshotListener { querySnapshot, error in
            if error == nil && querySnapshot != nil {
                var notes = [Note]()
                
                for doc in querySnapshot!.documents {
                    
                    // curred
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
    
    func updateStarredStatus(_ docId: String, _ isStarred: Bool) {
        let db = Firestore.firestore()
        db.collection("notes").document(docId).updateData(["isStarred": isStarred]) { error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("is starred changed successfully")
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
