//
//  LikeModel.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit
import Firebase

struct LikeModel {
    
    let projectID: String
    var userIDs: [String] = []
}

class Like {
    
    private let model: LikeModel
    
    var projectID: String { return model.projectID }
    var userIDs: [String] { return model.userIDs }
    
    init(model: LikeModel) {
        self.model = model
    }
}

//MARK: - Convenience

extension Like {
    
    convenience init(projectID: String, dict: [String: Any]) {
        var userIDs: [String] = []
        
        for (key, _) in dict {
            if !userIDs.contains(key) {
                userIDs.append(key)
            }
        }
        
        let model = LikeModel(projectID: projectID, userIDs: userIDs)
        self.init(model: model)
    }
}

//MARK: - Save

extension Like {
    
    func saveLike(completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Like.fetchLike(projectID: projectID) { like in
            let doc = Firestore.firestore()
                .collection("Likes")
                .document(self.projectID)
                
            if like != nil {
                doc.updateData([userID: true], completion: completion)
                 
            } else {
                doc.setData([userID: true], completion: completion)
            }
        }
    }
}

//MARK: - Fetch

extension Like {
    
    ///Get from a Project
    class func fetchLike(projectID: String, completion: @escaping (Like?) -> Void) {
        Firestore.firestore()
            .collection("Likes")
            .document(projectID)
            .getDocument(completion: { snapshot, error in
                var like: Like? = nil
                
                if let error = error {
                    print("getLikes error: \(error.localizedDescription)")
                    
                } else {
                    if let snapshot = snapshot, let dict = snapshot.data() {
                        let prID = snapshot.documentID
                        like = Like(projectID: prID, dict: dict)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(like)
                }
            })
    }
    
    ///Get Like from All Projects
    class func fetchLikes(completion: @escaping ([Like]) -> Void) {
        Firestore.firestore()
            .collection("Likes")
            .addSnapshotListener({ snapshot, error in
                var likes: [Like] = []
                
                if let error = error {
                    print("getLikes error: \(error.localizedDescription)")
                    
                } else {
                    if let snapshot = snapshot {
                        likes = snapshot.documents.map({ Like(projectID: $0.documentID, dict: $0.data()) })
                    }
                }
                
                DispatchQueue.main.async {
                    completion(likes)
                }
            })
    }
}

//MARK: - Delete

extension Like {
    
    func deleteLike(completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
            .collection("Likes")
            .document(projectID)
            .updateData([userID: FieldValue.delete()], completion: completion)
    }
}

//MARK: - Equatable

extension Like: Equatable {}
func == (lhs: Like, rhs: Like) -> Bool {
    return lhs.projectID == rhs.projectID
}
