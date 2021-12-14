//
//  PhotosAndVideos.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit
import MobileCoreServices
import AVFoundation

class PhotoVideo: NSObject {
    
    override init() {
        super.init()
    }
    
    static let shared = PhotoVideo()
    
    func takePhoto(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let image = kUTTypeImage as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPC.sourceType = .camera
            
            if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
                if available.contains(image) {
                    imgPC.mediaTypes = [image]
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.front) {
                    imgPC.cameraDevice = .front
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                    imgPC.cameraDevice = .rear
                }
            }
            
        } else {
            return
        }
        
        imgPC.showsCameraControls = true
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .fullScreen
        vc.present(imgPC, animated: true, completion: nil)
    }

    func photoFromLibrary(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let image = kUTTypeImage as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ||
            !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imgPC.sourceType = .photoLibrary
            
            if let available = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if available.contains(image) {
                    imgPC.mediaTypes = [image]
                }
            }
            
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imgPC.sourceType = .savedPhotosAlbum
            
            if let available = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if available.contains(image) {
                    imgPC.mediaTypes = [image]
                }
            }
            
        } else {
            return
        }
        
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .fullScreen
        vc.present(imgPC, animated: true, completion: nil)
    }

    func videoFromLibrary(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let movie = kUTTypeMovie as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ||
            !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imgPC.sourceType = .photoLibrary
            
            if let available = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if available.contains(movie) {
                    imgPC.mediaTypes = [movie]
                }
            }
            
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imgPC.sourceType = .savedPhotosAlbum
            
            if let available = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if available.contains(movie) {
                    imgPC.mediaTypes = [movie]
                }
            }
            
        } else {
            return
        }
        
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .fullScreen
        vc.present(imgPC, animated: true, completion: nil)
    }

    func video(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let movie = kUTTypeMovie as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPC.sourceType = .camera
            
            if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
                if available.contains(movie) {
                    imgPC.mediaTypes = [movie]
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.front) {
                    imgPC.cameraDevice = .front
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                    imgPC.cameraDevice = .rear
                }
            }
            
        } else {
            return
        }
        
        imgPC.showsCameraControls = true
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .fullScreen
        vc.present(imgPC, animated: true, completion: nil)
    }

    func camera(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
        let image = kUTTypeImage as String
        let movie = kUTTypeMovie as String
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPC.sourceType = .camera
            
            if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
                if available.contains(image) {
                    imgPC.mediaTypes = [image, movie]
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.front) {
                    imgPC.cameraDevice = .front
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                    imgPC.cameraDevice = .rear
                }
            }
            
        } else {
            return
        }
        
        imgPC.showsCameraControls = true
        imgPC.allowsEditing = edit
        imgPC.modalPresentationStyle = .fullScreen
        vc.present(imgPC, animated: true, completion: nil)
    }
    
    func getPhotoFromVideo(videoURL: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var image: UIImage?
            
            let asset = AVURLAsset(url: videoURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            let make = CMTimeMake(value: 2, timescale: 60)
            
            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            do {
                let cgImage = try generator.copyCGImage(at: make, actualTime: nil)
                image = UIImage(cgImage: cgImage)
                
            } catch let error as NSError {
                print("Get Image Error: \(error.localizedDescription)")
            }
        }
    }
}
