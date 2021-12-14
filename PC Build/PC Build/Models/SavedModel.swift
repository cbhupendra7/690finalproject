//
//  SavedModel.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit
import Firebase

struct SavedModel {
    
    var userID: String = ""
    var projectIDs: [String] = []
}

class Saved {
    
    private let model: SavedModel
    
    var userID: String { return model.userID }
    var projectIDs: [String] { return model.projectIDs }
    
    init(model: SavedModel) {
        self.model = model
    }
}

//MARK: - Convenience

extension Saved {
    
    convenience init(userID: String, dict: [String: Any]) {
        var projectIDs: [String] = []
        
        for (key, _) in dict {
            if !projectIDs.contains(key) {
                projectIDs.append(key)
            }
        }
        
        let model = SavedModel(userID: userID, projectIDs: projectIDs)
        self.init(model: model)
    }
}

//MARK: - Save

extension Saved {
    
    func saveSaved(prID: String, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Saved.fetchSaved { saved in
            let doc = Firestore.firestore()
                .collection("Saved")
                .document(userID)
                
            if saved != nil {
                doc.updateData([prID: true], completion: completion)
                 
            } else {
                doc.setData([prID: true], completion: completion)
            }
        }
    }
}

//MARK: - Fetch

extension Saved {
    
    ///Get from a User
    class func fetchSaved(isListener: Bool = false, completion: @escaping (Saved?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let doc = Firestore.firestore()
            .collection("Saved")
            .document(userID)
        
        if isListener {
            doc.addSnapshotListener { snapshot, error in
                var saved: Saved? = nil
                
                if let error = error {
                    print("getSaveds error: \(error.localizedDescription)")
                    
                } else {
                    if let snapshot = snapshot, let dict = snapshot.data() {
                        let userID = snapshot.documentID
                        saved = Saved(userID: userID, dict: dict)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(saved)
                }
            }
            
        } else {
            doc.getDocument(completion: { snapshot, error in
                var saved: Saved? = nil
                
                if let error = error {
                    print("getSaveds error: \(error.localizedDescription)")
                    
                } else {
                    if let snapshot = snapshot, let dict = snapshot.data() {
                        let userID = snapshot.documentID
                        saved = Saved(userID: userID, dict: dict)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(saved)
                }
            })
        }
    }
    
    ///Get Saved from All Projects
    class func fetchArraySaved(completion: @escaping ([Saved]) -> Void) {
        Firestore.firestore()
            .collection("Saved")
            .addSnapshotListener({ snapshot, error in
                var array: [Saved] = []
                
                if let error = error {
                    print("getSaveds error: \(error.localizedDescription)")
                    
                } else {
                    if let snapshot = snapshot {
                        array = snapshot.documents.map({ Saved(userID: $0.documentID, dict: $0.data()) })
                    }
                }
                
                DispatchQueue.main.async {
                    completion(array)
                }
            })
    }
}

//MARK: - Delete

extension Saved {
    
    func deleteSaved(prID: String, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
            .collection("Saved")
            .document(userID)
            .updateData([prID: FieldValue.delete()], completion: completion)
    }
}

//MARK: - Equatable

extension Saved: Equatable {}
func == (lhs: Saved, rhs: Saved) -> Bool {
    return lhs.userID == rhs.userID
}
