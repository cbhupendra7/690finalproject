//
//  ImagePickerHelper.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class ImagePickerHelper: NSObject {
    
    private var vc: UIViewController
    private var completion: ((UIImage?) -> Void)
    private let imgPicker = UIImagePickerController()
    private var superview: UIView
    
    init(vc: UIViewController, superview: UIView, completion: @escaping (UIImage?) -> Void) {
        self.vc = vc
        self.completion = completion
        self.superview = superview
        
        super.init()
        imgPicker.delegate = self
        showPicker()
    }
}

extension ImagePickerHelper {
    
    func showPicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let videoFromLibraryAct = UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            PhotoVideo.shared.photoFromLibrary(self.vc, imgPC: self.imgPicker, edit: false)
        })
        
        let takePhotoAct = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            PhotoVideo.shared.takePhoto(self.vc, imgPC: self.imgPicker, edit: false)
        })
        
        let cancelAC = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(videoFromLibraryAct)
        alert.addAction(takePhotoAct)
        alert.addAction(cancelAC)
        
        vc.present(alert, animated: true, completion: nil)
    }
}

extension ImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        
        if let editedIMG = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = editedIMG
            
        } else if let originIMG = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = originIMG
        }
        
        vc.dismiss(animated: true) {
            self.completion(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
