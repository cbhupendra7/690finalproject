//
//  SquareImage.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class SquareImage: NSObject {
    
    static let shared = SquareImage()
    
    override init() {
        super.init()
    }
    
    //Crop image to square
    func squareImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let image = cropImage(image)
        let size = image.size
        
        let wR: CGFloat = targetSize.width / size.width
        let hR: CGFloat = targetSize.height / size.height
        
        let newSize: CGSize
        
        if wR > hR {
            newSize = CGSize(width: size.width * hR, height: size.height * hR)
            
        } else {
            newSize = CGSize(width: size.width * wR, height: size.height * wR)
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
    
    private func cropImage(_ image: UIImage) -> UIImage {
        let originalW: CGFloat = image.size.width
        let originalH: CGFloat = image.size.height
        
        let newWidth: CGFloat = originalW > originalH ? originalH : originalW
        let posX: CGFloat = (originalW - newWidth)/2
        let posY: CGFloat = (originalH - newWidth)/2
        let rect = CGRect(x: posX, y: posY, width: newWidth, height: newWidth)
        
        let crop = image.cgImage?.cropping(to: rect)
        let scale = UIScreen.main.scale
        
        let newImage = UIImage(cgImage: crop!, scale: scale, orientation: image.imageOrientation)
        
        return newImage
    }
}
