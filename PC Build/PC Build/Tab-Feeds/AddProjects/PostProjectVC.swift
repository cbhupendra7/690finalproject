//
//  PostProjectVC.swift
//  RollingRobots
//
//  Created by Thanh Hoang on 24/09/2021.
//

import UIKit

class PostProjectVC: UIViewController {
    
    //MARK: - Properties
    let scrollView = PostScrollView()
    
    var containerView: PostContainerView { return scrollView.containerView }
    var titleView: PostTitleView { return containerView.titleView }
    var desView: PostDescriptionView { return containerView.desView }
    var addView: PostAddView { return containerView.addView }
    var imagesView: PostImagesView { return containerView.imagesView }
    var imagesCV: UICollectionView { return imagesView.collectionView }
    
    //Edit Project
    var isEdit = false
    
    //Update or create new Project
    var titleTxt = ""
    var desTxt = ""
    var desCount = ""
    
    //Post
    var projectPhoto: UIImage?
    private var selectedIndex: Int?
    var hud: HUD?
    
    //Edit Projet
    var project: Project!
    var updatePr: Project!
    
    //Delete Post
    var imageIDArray: [String] = []
    
    var photoPickerHelper: ImagePickerHelper?
    
    private var viewModel: PostProjectViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi()
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { notif in
            let key = UIResponder.keyboardFrameEndUserInfoKey
            if let height = (notif.userInfo?[key] as AnyObject).cgRectValue?.height {
                self.scrollView.contentInset.bottom = height
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { notif in
            self.scrollView.contentInset.bottom = 0.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Setups

extension PostProjectVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        title = !isEdit ? "Add Post" : "Edit Post"
        viewModel = PostProjectViewModel(vc: self)
        
        //TODO: - ScrollView
        scrollView.setupViews(self, dl: self)
        scrollView.keyboardDismissMode = .onDrag
        
        titleView.textField.delegate = self
        titleView.textField.returnKeyType = .done

        desView.textView.delegate = self
        desView.textView.addDoneBtn(target: self, selector: #selector(endTV))

        addView.photoBtn.delegate = self
        
        imagesCV.dataSource = self
        imagesCV.delegate = self
        
        if let pr = project {
            updatePr = Project(model: pr.model)
            
        } else {
            let model = ProjectModel(uid: "", title: "")
            updatePr = Project(model: model)
        }
        
        if isEdit {
            titleTxt = updatePr.title
        }
        
        imagesView.isHidden = updatePr.posts.count == 0
        updateUI()
    }
    
    private func setupNavi() {
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveHandler))
        
        if isEdit {
            let sp: CGFloat = 8.0
            let delBtn = ButtonAnimation(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
            delBtn.setImage(UIImage(named: "icon-trash"), for: .normal)
            delBtn.contentEdgeInsets = UIEdgeInsets(top: sp, left: sp, bottom: sp, right: sp)
            delBtn.tag = 2
            delBtn.delegate = self
            
            let delView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
            delView.addSubview(delBtn)
            
            let delBar = UIBarButtonItem(customView: delView)
            navigationItem.setRightBarButtonItems([saveBtn, delBar], animated: true)
            
        } else {
            navigationItem.setRightBarButtonItems([saveBtn], animated: true)
        }
    }
    
    func updateUI() {
        titleView.textField.text = updatePr.title
        
        let desTxt = updatePr.description
        let count = desTxt == nil ? 0 : desTxt!.count
        
        desView.textView.text = desTxt == nil ? "Description" : desTxt
        desView.textView.textColor = desTxt == nil ? .placeholderText : .black
        desView.countLbl.text = "\(count)/400"
    }
    
    @objc private func cancelHandler() {
        navigationController?.popViewController(animated: true)
    }
    
    private func endEditing() {
        titleView.textField.resignFirstResponder()
        endTV()
        
        for cell in imagesView.collectionView.visibleCells {
            if let cell = cell as? PostImagesCVCell {
                cell.desTV.resignFirstResponder()
            }
        }
    }
    
    func reloadData() {
        imagesView.isHidden = updatePr.posts.count == 0
        imagesView.reloadData()
    }
    
    @objc private func endTV() {
        desView.textView.resignFirstResponder()
    }
}

//MARK: - Save

extension PostProjectVC {
    
    @objc private func saveHandler() {
        endEditing()
        
        if titleTxt == "" && desTxt == "" {
            print("Not Not Not")
            return
        }
        
        hud = HUD.hud(kWindow)
        viewModel.saveHandler()
    }
}

//MARK: - UIScrollViewDelegate

extension PostProjectVC: UIScrollViewDelegate {}

//MARK: - ButtonAnimationDelegate

extension PostProjectVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Add Photo
            viewModel.handlePhotoEditing()
            
        } else if sender.tag == 2 { //Delete
            handleDelete()
        }
    }
    
    func handleDelete() {
        let alert = UIAlertController(title: "Are you sure want to delete this project?", message: nil, preferredStyle: .alert)
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAct = UIAlertAction(title: "Delete", style: .default) { _ in
            let hud = HUD.hud(kWindow)
            
            self.updatePr.deleteProject {
                hud.removeHUD {}
                self.viewModel.popHandler()
            }
        }
        
        alert.addAction(cancelAct)
        alert.addAction(okAct)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDataSource

extension PostProjectVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return updatePr.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImagesCVCell.id, for: indexPath) as! PostImagesCVCell
        viewModel.setupCell(cell, indexPath: indexPath)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension PostProjectVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PostProjectVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemW: CGFloat = 180 * 16 / 9
        let itemH = collectionView.bounds.height
        
        return CGSize(width: itemW, height: itemH)
    }
}

//MARK: - UITextFieldDelegate

extension PostProjectVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleView.textField {
            if let text = textField.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty {
                titleTxt = text
                
            } else {
                titleTxt = ""
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let txt = textField.text, let range = Range(range, in: txt) else {
            return false
        }
        let sub = txt[range]
        let count = txt.count - sub.count + string.count
        
        return count < 64
    }
}

//MARK: - UITextViewDelegate

extension PostProjectVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == desView.textView {
            if textView.text == "Description" {
                textView.textColor = .black
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == desView.textView {
            var txt = ""
            if textView.text == "" {
                textView.textColor = .placeholderText
                textView.text = "Description"
                txt = textView.text
            }
            
            if txt == "", let text = textView.text,
               !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                desTxt = text
                
            } else {
                desTxt = ""
                
                textView.textColor = .placeholderText
                textView.text = "Description"
                
                desCount = "0/400"
                desView.countLbl.text = desCount
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == desView.textView {
            guard let txt = textView.text, let range = Range(range, in: txt) else {
                return false
            }
            let sub = txt[range]
            let count = txt.count - sub.count + text.count
            
            desCount = "\(count)/400"
            desView.countLbl.text = desCount
            
            return count < 400
        }
        
        return false
    }
}

//MARK: - PostImagesCVCellDelegate

extension PostProjectVC: PostImagesCVCellDelegate {
    
    func deleteDidTap(_ cell: PostImagesCVCell) {
        endEditing()
        
        if let indexPath = imagesCV.indexPath(for: cell) {
            if let imageURL = updatePr.posts[indexPath.item].imageURL {
                let uid = URL(string: imageURL)!.lastPathComponent
                imageIDArray.append(uid)
            }
            
            imagesCV.performBatchUpdates {
                updatePr.model.posts.remove(at: indexPath.item)
                imagesCV.deleteItems(at: [indexPath])
                
            } completion: { _ in
                self.reloadData()
            }
        }
    }
}
