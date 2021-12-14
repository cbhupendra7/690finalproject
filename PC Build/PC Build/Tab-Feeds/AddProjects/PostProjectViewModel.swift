//
//  PostProjectViewModel.swift
//  RollingRobots
//
//  Created by Thanh Hoang on 24/09/2021.
//

import UIKit
import AVFoundation

class PostProjectViewModel: NSObject {
    
    //MARK: - Properties
    private var vc: PostProjectVC
    
    //MARK: - Initializes
    init(vc: PostProjectVC) {
        self.vc = vc
    }
}

//MARK: - Setups

extension PostProjectViewModel {
    
    func handlePhotoEditing() {
        let view = vc.addView
        vc.photoPickerHelper = ImagePickerHelper(vc: vc, superview: view, completion: { image in
            self.vc.projectPhoto = image
            
            let model = PostModel(imageEdit: image)
            let post = Post(model: model)
            self.vc.updatePr.model.posts.insert(post, at: 0)
            
            self.vc.reloadData()
        })
    }
    
    func handleDelete() {
        let alert = UIAlertController(title: "Are you sure want to delete this project?", message: nil, preferredStyle: .alert)
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAct = UIAlertAction(title: "Delete", style: .default) { _ in
            let hud = HUD.hud(kWindow)
            
            self.vc.updatePr.deleteProject {
                hud.removeHUD {}
                self.popHandler()
            }
        }
        
        alert.addAction(cancelAct)
        alert.addAction(okAct)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func popHandler() {
        if let navi = vc.navigationController {
            let vcs = navi.viewControllers

            for vc in vcs {
                if vc.isKind(of: FeedVC.self), let index = vcs.firstIndex(of: vc) {
                    (vcs[index] as! FeedVC).getProjects()
                    vc.navigationController?.popToViewController(vcs[index], animated: true)
                    return
                }
            }
        }
    }
}

//MARK: - Save

extension PostProjectViewModel {
    
    func saveHandler() {
        vc.imageIDArray.forEach({
            FirebaseStorage.deletePhotoProject(fileName: $0) { error in
                if let error = error {
                    print("deletePhotoProject error: \(error.localizedDescription)")

                } else {
                    print("deletePhotoProject success")
                }
            }
        })
        
        if vc.titleTxt != "" {
            vc.updatePr.model.title = vc.titleTxt
        }

        if vc.desTxt != "" {
            vc.updatePr.model.description = vc.desTxt
        }

        if !vc.isEdit {
            if vc.titleTxt == "" {
                vc.updatePr.model.title = "New Post"
            }
        }
        
        if vc.updatePr.posts.count != 0 {
            savePost(0, posts: vc.updatePr.posts)

        } else {
            saveProject()
        }
    }
    
    private func savePost(_ index: Int, posts: [Post]) {
        if index < posts.count {
            let post = posts[index]
            let group = DispatchGroup()
            
            if post.imageEdit != nil {
                group.enter()
                
                post.saveImageURL(post.imageEdit, fileName: UUID().uuidString) { link in
                    self.vc.updatePr.posts[index].model.imageURL = link
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.savePost(index+1, posts: posts)
                
                if index == posts.count - 1 {
                    print("SUCCESSFULLY")
                    self.saveProject()
                }
            }
            
            return
        }
    }
    
    func saveProject() {
        vc.updatePr.saveProject {
            self.vc.hud?.removeHUD {}
            self.popHandler()
        }
    }
}

//MARK: - SetupCells

extension PostProjectViewModel {
    
    func setupCell(_ cell: PostImagesCVCell, indexPath: IndexPath) {
        let post = vc.updatePr.posts[indexPath.row]
        
        if let imageURL = post.imageURL {
            cell.featuredImgView.isHidden = false
            
            DownloadImage.shared.downloadImage(link: imageURL) { image in
                cell.featuredImgView.image = image
            }
        }
        
        //Edit
        if let image = post.imageEdit {
            cell.featuredImgView.isHidden = false
            cell.featuredImgView.image = image
        }
        
        cell.desTV.text = post.description == nil ? "Description" : post.description
        cell.desTV.textColor = post.description == nil ? .placeholderText : .black
        
        cell.delegate = vc
        cell.vc = vc
    }
}
