//
//  FirebaseStorage.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit
import Firebase

class FirebaseStorage {
    
    var image: UIImage?
    var videoURL: URL?
    var audioURL: URL?
    
    init(image: UIImage?) {
        self.image = image
    }
    
    init(videoURL: URL?) {
        self.videoURL = videoURL
    }
    
    init(audioURL: URL?) {
        self.audioURL = audioURL
    }
}

//MARK: - Profile - Avatar

extension FirebaseStorage {
    
    func uploadAvatar(completion: @escaping (String?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let image = image else {
            return
        }
        
        let imgSize = image.size
        let height = imgSize.width > imgSize.height ? imgSize.height : imgSize.width
        
        let setSize = CGSize(width: height, height: height)
        let newImage = SquareImage.shared.squareImage(image, targetSize: setSize)
        
        if let data = newImage.jpegData(compressionQuality: 1.0) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            let ref = Storage.storage()
                .reference(withPath: "Users")
                .child(userUID)
                .child("images")
                .child("profile-photo.jpg")
            
            ref.putData(data, metadata: metadata) { metadata, error in
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                ref.downloadURL { url, error in
                    guard let url = url, error == nil else {
                        completion(nil)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(url.absoluteString)
                    }
                }
            }
        }
    }
    
    class func deleteUser(completion: @escaping () -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Storage.storage().reference(withPath: "Users/\(userUID)")
        
        let group = DispatchGroup()
        group.enter()
        
        group.enter()
        ref.child("images/profile-photo.jpg").delete { error in
            group.leave()
            
            if let error = error {
                print("deleteUser profilePhoto error: \(error.localizedDescription)")
            }
        }
        
        group.notify(queue: .main) {
            print("deleteUserOnStorage SUCCESSFULLY")
            completion()
        }
    }
}

//MARK: - Project - Photos

extension FirebaseStorage {
    
    func uploadPhotoProject(fileName: String, completion: @escaping (String?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        guard let image = image else {
            return
        }
        
        let newImage = image.resizeImage()
        
        if let data = newImage.jpegData(compressionQuality: 1.0) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            let ref = Storage.storage()
                .reference(withPath: "Users")
                .child(userUID)
                .child("images")
                .child("projects")
                .child("\(fileName).jpg")
            
            ref.putData(data, metadata: metadata) { metadata, error in
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                ref.downloadURL { url, error in
                    guard let url = url, error == nil else {
                        completion(nil)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(url.absoluteString)
                    }
                }
            }
        }
    }
    
    class func deletePhotoProject(fileName: String, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        Storage.storage()
            .reference(withPath: "Users")
            .child(userUID)
            .child("images")
            .child("projects")
            .child(fileName)
            .delete(completion: completion)
    }
}
