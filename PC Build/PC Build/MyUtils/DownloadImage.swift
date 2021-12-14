//
//  DownloadImage.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit
import SDWebImage

class DownloadImage: NSObject {
    
    //MARK: - Properties
    static let shared = DownloadImage()
    
    override init() {
        super.init()
    }
}

//MARK: - Setups

extension DownloadImage {
    
    //Download images from the link
    func downloadImage(link: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: link)
        
        SDWebImageManager.shared.loadImage(
            with: url,
            options: [.continueInBackground],
            progress: nil) { image, _, _, _, _, _ in
                OperationQueue.main.addOperation {
                    completion(image)
                }
            }
    }
    
    func removeCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: nil)
    }
}
