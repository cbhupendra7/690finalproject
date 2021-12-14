//
//  UserModel.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit
import Firebase

class UserProject {
    
    var user: User
    var projects: [Project]
    
    init(user: User, projects: [Project]) {
        self.user = user
        self.projects = projects
    }
}

extension UserProject: Equatable {}
func == (lhs: UserProject, rhs: UserProject) -> Bool {
    return lhs.user.uid == rhs.user.uid
}

/****************************************************************************************************************/

struct UserModel {
    
    let uid: String
    var name: String
    let email: String
    var receiveNewsletter = false
    var bio: String? = nil
    var profileImageURL: String? = nil //Avatar
    var joinedDate: Timestamp? = Timestamp(date: Date())
    
    var profileImageEdit: UIImage? = nil //Avatar
}

class User {
    
    var model: UserModel
    
    var uid: String { return model.uid }
    var name: String { return model.name }
    var email: String { return model.email }
    var receiveNewsletter: Bool { return model.receiveNewsletter }
    var bio: String? { return model.bio }
    var profileImageURL: String? { return model.profileImageURL }
    var joinedDate: Timestamp? { return model.joinedDate }
    
    var profileImageEdit: UIImage? { return model.profileImageEdit }
    
    static let signOutKey = "NewSignOutKey"
    
    init(model: UserModel) {
        self.model = model
    }
}

//MARK: - Convenience

extension User {
    
    convenience init(uid: String, dict: [String: Any]) {
        let name = dict["name"] as? String ?? ""
        let email = dict["email"] as? String ?? ""
        let receiveNewsletter = dict["receiveNewsletter"] as? Bool ?? false
        let bio = dict["bio"] as? String
        let profileURL = dict["profileImageURL"] as? String
        let joinedDate = dict["joined-date"] as? Timestamp
        
        let model = UserModel(uid: uid,
                              name: name,
                              email: email,
                              receiveNewsletter: receiveNewsletter,
                              bio: bio,
                              profileImageURL: profileURL,
                              joinedDate: joinedDate)
        self.init(model: model)
    }
}

//MARK: - Account

extension User {
    
    class func reloadCurrentUser(completion: @escaping () -> Void) {
        Auth.auth().currentUser?.reload(completion: { _ in
            completion()
        })
    }
    
    class func checkUserAlreadyExists(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { emails, error in
            var exists = false
            if error == nil, let emails = emails {
                exists = emails.count != 0
            }
            
            completion(exists)
        }
    }
    
    class func createAccount(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    class func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    class func signOut(completion: @escaping () -> Void) {
        do {
            UserDefaults.standard.setValue(false, forKey: User.signOutKey)
            
            try Auth.auth().signOut()
            completion()
            
        } catch {}
    }
}

//MARK: - Save

extension User {
    
    func saveUser(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("Users")
            .document(uid)
            .setData(toDict(), completion: completion)
    }
    
    private func toDict() -> [String: Any] {
        return [
            "name": name,
            "email": email,
            "receiveNewsletter": receiveNewsletter,
            "joinedDate": joinedDate ?? Timestamp()
        ]
    }
}

//MARK: - Update

extension User {
    
    func updateUser(completion: @escaping (Error?) -> Void) {
        var dict: [String: Any] = ["name": name]
        
        dict["profileImageURL"] = profileImageURL ?? FieldValue.delete()
        dict["bio"] = bio ?? FieldValue.delete()
        
        Firestore.firestore()
            .collection("Users")
            .document(uid)
            .updateData(dict, completion: completion)
    }
    
    func updateAvatar(newImage: UIImage?, completion: @escaping (String?) -> Void) {
        let storage = FirebaseStorage(image: newImage)
        storage.uploadAvatar(completion: completion)
    }
}

//MARK: - Fetch

extension User {
    
    class func fetchCurrentUser(completion: @escaping (User?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        fetchUser(userUID: userUID, isListener: true, completion: completion)
    }
    
    ///The default value of isListener is false
    class func fetchUser(userUID: String, isListener: Bool = false, completion: @escaping (User?) -> Void) {
        let doc = Firestore.firestore().collection("Users").document(userUID)
        
        if isListener {
            doc.addSnapshotListener { snapshot, error in
                fetchUser(snapshot: snapshot, error: error, completion: completion)
            }
            
        } else {
            doc.getDocument { snapshot, error in
                fetchUser(snapshot: snapshot, error: error, completion: completion)
            }
        }
    }
    
    private class func fetchUser(snapshot: DocumentSnapshot?, error: Error?, completion: @escaping (User?) -> Void) {
        var user: User?
        
        if let error = error {
            print("fetchUser error: \(error.localizedDescription)")
            
        } else {
            if let snapshot = snapshot, let dict = snapshot.data() {
                user = User(uid: snapshot.documentID, dict: dict)
            }
        }
        
        DispatchQueue.main.async {
            completion(user)
        }
    }
    
    class func fetchAllUser(completion: @escaping ([User]) -> Void) {
        Firestore
            .firestore()
            .collection("Users")
            .getDocuments { snapshot, error in
                var users: [User] = []
                
                if let error = error {
                    print("fetchAllUser error: \(error.localizedDescription)")
                    
                } else {
                    if let snapshot = snapshot {
                        users = snapshot.documents.map({ User(uid: $0.documentID, dict: $0.data()) })
                        users = users.sorted(by: { $0.name < $1.name })
                    }
                }
                
                DispatchQueue.main.async {
                    completion(users)
                }
            }
    }
}

//MARK: - Delete

extension User {
    
    class func removeUser(userUID: String, prUIDs: [String], completion: @escaping () -> Void) {
        FirebaseStorage.deleteUser {
            let db = Firestore.firestore()
            
            let doc = db
                .collection("Users")
                .document(userUID)
            
            let group = DispatchGroup()
            group.enter()
            
            if prUIDs.count != 0 {
                for i in 0..<prUIDs.count {
                    let prUID = prUIDs[i]
                    
                    doc.collection("projects").document(prUID).delete { error in
                        if i == prUIDs.count-1 {
                            doc.delete { _ in
                                group.leave()
                            }
                        }
                    }
                }
                
            } else {
                doc.delete { _ in
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion()
            }
        }
    }
}

//MARK: - Equatable

extension User: Equatable {}
func == (lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}
