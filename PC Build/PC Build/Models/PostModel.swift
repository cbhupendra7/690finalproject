//
//  PostModel.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit
import Firebase

struct PostModel {
    
    var description: String? = nil
    var imageURL: String? = nil
    var createdDate: Timestamp? = Timestamp(date: Date())
    
    //Edit Project
    var imageEdit: UIImage? = nil
}

class Post {
    
    var model: PostModel
    
    var description: String? { return model.description }
    var imageURL: String? { return model.imageURL }
    var createdDate: Timestamp? { return model.createdDate }
    
    var imageEdit: UIImage? { return model.imageEdit }
    
    init(model: PostModel) {
        self.model = model
    }
}

//MARK: - Convenience

extension Post {
    
    convenience init(dict: [String: Any]) {
        let description = dict["description"] as? String
        let imageURL = dict["image-url"] as? String
        let createdDate = dict["created-date"] as? Timestamp
        
        let model = PostModel(
            description: description,
            imageURL: imageURL,
            createdDate: createdDate)
        
        self.init(model: model)
    }
}

//MARK: - Save Post From User

extension Post {
    
    func saveImageURL(_ image: UIImage?, fileName: String, completion: @escaping (String?) -> Void) {
        let storage = FirebaseStorage(image: image)
        storage.uploadPhotoProject(fileName: fileName, completion: completion)
    }
}
