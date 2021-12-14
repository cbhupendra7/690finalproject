//
//  UIImage+Ext.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

extension UIImage {
    
    func resizeImage() -> UIImage {
        let height: CGFloat = 1000.0
        let scale = size.width/size.height
        let width = height * scale
        let newSize = CGSize(width: width, height: height)
        let newRect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: newRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
