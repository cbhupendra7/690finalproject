//
//  ProjectModel.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit
import Firebase

struct ProjectModel {
    
    let uid: String
    var title: String
    var description: String? = nil
    var posts: [Post] = []
    var createdDate: Timestamp? = Timestamp(date: Date())
    
    var user: User? = nil
    var like: Like? = nil
    var saved: Saved? = nil
}

class Project {
    
    var model: ProjectModel
    
    var uid: String { return model.uid }
    var title: String { return model.title }
    var description: String? { return model.description }
    var posts: [Post] { return model.posts }
    var createdDate: Timestamp? { return model.createdDate }
    
    var user: User? { return model.user }
    var like: Like? { return model.like }
    var saved: Saved? { return model.saved }
    
    init(model: ProjectModel) {
        self.model = model
    }
}

//MARK: - Convenience

extension Project {
    
    convenience init(uid: String, dict: [String: Any]) {
        let title = dict["title"] as? String ?? ""
        let description = dict["description"] as? String
        let createdDate = dict["created-date"] as? Timestamp
        
        var posts: [Post] = []
        if let array = dict["posts"] as? NSArray {
            for dict in array {
                if let dict = dict as? [String: Any] {
                    let model = Post(dict: dict)
                    posts.append(model)
                }
            }
        }
        
        posts = posts.sorted(by: {
            $0.createdDate!.dateValue() > $1.createdDate!.dateValue()
        })
        
        let model = ProjectModel(
            uid: uid,
            title: title,
            description: description,
            posts: posts,
            createdDate: createdDate)
        self.init(model: model)
    }
}

//MARK: - Save

extension Project {
    
    func saveProject(completion: @escaping () -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let collection = Firestore.firestore()
            .collection("Users")
            .document(userUID)
            .collection("projects")
        
        if uid == "" { //If create new
            let doc = collection.document()
            doc.setData(toDictionary()) { error in
                if let error = error {
                    print("saveProject error: \(error.localizedDescription)")
                }
                
                self.updateData(doc, completion: completion)
            }
            
        } else { //If edit
            let doc = collection.document(uid)
            doc.updateData(toDictionary()) { error in
                if let error = error {
                    print("saveProject error: \(error.localizedDescription)")
                }
                
                self.updateData(doc, completion: completion)
            }
        }
    }
    
    private func updateData(_ doc: DocumentReference, completion: @escaping () -> Void) {
        if let description = self.description {
            doc.updateData(["description": description])
        }
        
        var array: [[String: Any]] = []
        for post in self.posts {
            var dict: [String: Any] = [:]
            
            if let str = post.description {
                dict["description"] = str
            }
            
            if let str = post.imageURL {
                dict["image-url"] = str
            }
            
            let date = post.createdDate ?? Timestamp(date: Date())
            dict["created-date"] = date
            
            array.append(dict)
        }
        
        if self.posts.count != 0 {
            doc.updateData(["posts": array])
        }
        
        completion()
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "created-date": createdDate ?? Timestamp(date: Date())
        ]
    }
}

//MARK: - Fetch

extension Project {
    
    ///Get Projects from a User
    class func fetchProjects(userUID: String, completion: @escaping ([Project]) -> Void) {
        Firestore.firestore()
            .collection("Users")
            .document(userUID)
            .collection("projects")
            .getDocuments { snapshot, error in
                var projects: [Project] = []
                
                if let error = error {
                    print("fetchProjects error: \(error.localizedDescription)")
                    
                } else {
                    if let snapshot = snapshot {
                        projects = snapshot.documents.map({
                            Project(uid: $0.documentID, dict: $0.data())
                        })
                        projects = projects.sorted(by: {
                            $0.createdDate!.dateValue() > $1.createdDate!.dateValue()
                        })
                    }
                }
                
                DispatchQueue.main.async {
                    completion(projects)
                }
            }
    }
    
    ///Get all Projects of all Users
    class func fetchProjects(completion: @escaping ([UserProject]) -> Void) {
        let start = DispatchTime.now().uptimeNanoseconds
        
        let coll = Firestore.firestore().collection("Users")
        coll.getDocuments(completion: { snapshot, error in
            if let error = error {
                print("getDocumentID error: \(error.localizedDescription)")
                
            } else {
                if let snapshot = snapshot {
                    var userPrs: [UserProject] = []
                    
                    let group = DispatchGroup()
                    group.enter()
                    
                    let users = snapshot.documents.map({ User(uid: $0.documentID, dict: $0.data()) })
                    let userUIDs = snapshot.documents.map({ $0.documentID })
                    
                    for i in 0..<userUIDs.count {
                        let userUID = userUIDs[i]
                        let col = coll.document(userUID).collection("projects")
                        
                        col.getDocuments { snapshot, error in
                            var projects: [Project] = []
                            
                            if let error = error {
                                print("fetchProjects error: \(error.localizedDescription)")
                                
                            } else {
                                if let snapshot = snapshot {
                                    projects = snapshot.documents.map({
                                        let pr = Project(uid: $0.documentID, dict: $0.data())
                                        pr.model.user = users.first(where: { $0.uid == userUID })
                                        
                                        return pr
                                    })
                                    
                                }
                            }
                            
                            if let user = users.first(where: { $0.uid == userUID }) {
                                let userPr = UserProject(user: user, projects: projects)
                                
                                if !userPrs.contains(userPr) {
                                    userPrs.append(userPr)
                                }
                            }
                            
                            if i == userUIDs.count - 1 {
                                group.leave()
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        let end = DispatchTime.now().uptimeNanoseconds
                        print("\((end - start)/1_000_000_000)s")
                        
                        DispatchQueue.main.async {
                            completion(userPrs)
                        }
                    }
                }
            }
        })
    }
}

//MARK: - Delete

extension Project {
    
    func deleteProject(completion: @escaping () -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        
        var imageArray: [String] = []
        
        for post in posts {
            if let link = post.imageURL {
                let str = URL(string: link)!.lastPathComponent
                imageArray.append(str)
            }
        }
        
        //Delete Photo on Storage
        if imageArray.count != 0 {
            group.enter()
            
            for i in 0..<imageArray.count {
                FirebaseStorage.deletePhotoProject(fileName: imageArray[i]) { error in
                    if let error = error {
                        print("deletePhotoProject error: \(error.localizedDescription)")
                        
                    } else {
                        print("deletePhotoProject success")
                    }
                    
                    if i == imageArray.count-1 {
                        group.leave()
                    }
                }
            }
        }
        
        group.enter()
        
        let doc = Firestore.firestore()
            .collection("Users")
            .document(userUID)
            .collection("projects")
            .document(self.uid)
        doc.delete { error in
            if let error = error {
                print("deleteProject error: \(error)")
            }
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

//MARK: - Equatable

extension Project: Equatable {}
func == (lhs: Project, rhs: Project) -> Bool {
    return lhs.uid == rhs.uid
}
