//
//  ThreeDotsModel.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit

class ThreeDotsModel {
    
    var title: String
    var image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    class func shared() -> [ThreeDotsModel] {
        var threeDots: [ThreeDotsModel] = []
        
        let edit = UIImage(named: "icon-pencil")
        let delete = UIImage(named: "icon-trash")
        
        threeDots.append(ThreeDotsModel(title: "Edit Post", image: edit))
        threeDots.append(ThreeDotsModel(title: "Delete Post", image: delete))
        
        return threeDots
    }
}
