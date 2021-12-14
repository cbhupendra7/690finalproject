//
//  EditProfileVC.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class EditProfileVC: UIViewController {
    
    //MARK: Properties
    let scrollView = EPrScrollView()
    var containerView: EPrContainerView { return scrollView.containerView }
    var avatarView: EPrAvatarView { return containerView.avatarView }
    var nameView: EPrNameView { return containerView.nameView }
    var bioView: EPrBioView { return containerView.bioView }
    
    private var bioCount = "0/400"
    var avatarPickerHelper: ImagePickerHelper?
    
    //Update
    var nameTxt = ""
    var bioTxt = ""
    
    //Load
    var user: User?
    var updateUser: User?
    
    //MARK: Lifecycle
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
            if let height = (notif.userInfo?[key] as? NSValue)?.cgRectValue.height {
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
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
}

//MARK: Setups

extension EditProfileVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Edit Profile"
        
        //TODO: - ScrollView
        scrollView.setupViews(self, dl: self)
        
        avatarView.editAvatarBtn.delegate = self
        
        nameView.textField.delegate = self
        bioView.textView.delegate = self
        
        let bio = user?.bio != nil ? user!.bio!.count : 0
        bioCount = "\(bio)/400"
        
        if let user = user {
            updateUser = User(model: user.model)
        }
        
        avatarView.updateUI(updateUser)
        nameView.textField.text = updateUser?.name
        
        bioView.textView.text = updateUser?.bio ?? "Bio"
        bioView.textView.textColor = updateUser?.bio == nil ? .placeholderText : .black
        bioView.textView.addDoneBtn(target: self, selector: #selector(endEditing))
        bioView.countLbl.text = bioCount
    }
    
    private func setupNavi() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveDidTap))
        (navigationController as? NavigationController)?.setupNaviBar(.white, bgColor: UIColor(hex: 0x3F7BEF), shadowColor: .clear, isDark: true)
        enabledSaveBtn()
    }
    
    @objc private func cancelDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func enabledSaveBtn() {
        let isBool = nameTxt != "" ||
        bioTxt != "" ||
        updateUser?.bio != user?.bio ||
        updateUser?.model.profileImageEdit != nil
        
        navigationItem.rightBarButtonItem?.isEnabled = isBool
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
}

//MARK: - Save

extension EditProfileVC {
    
    @objc private func saveDidTap() {
        endEditing()
        
        guard let newUser = updateUser else { return }

        let hud = HUD.hud(kWindow)
        let group = DispatchGroup()

        if nameTxt != "" {
            newUser.model.name = nameTxt
        }

        if let avatar = newUser.profileImageEdit {
            group.enter()
            
            newUser.updateAvatar(newImage: avatar) { link in
                newUser.model.profileImageURL = link
                group.leave()
            }
        }

        group.notify(queue: .main) {
            hud.removeHUD {}

            newUser.updateUser { error in
                if let error = error {
                    print("updateUser error: \(error.localizedDescription)")
                }

                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK: - UIScrollViewDelegate

extension EditProfileVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let defaultTop: CGFloat = 0.0
        var currentTop: CGFloat = defaultTop
        
        if offsetY < 0.0 {
            currentTop = offsetY
            avatarView.coverHeightLayout.constant = containerView.coverH - offsetY
            containerView.avatarHeightLayout.constant = containerView.avatarH - offsetY
            
        } else {
            avatarView.coverHeightLayout.constant = containerView.coverH
            containerView.avatarHeightLayout.constant = containerView.avatarH
        }
        
        self.scrollView.cvTopLayout.constant = currentTop
    }
}

//MARK: - ButtonAnimationDelegate

extension EditProfileVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Edit Avatar
            avatarPickerHelper = ImagePickerHelper(vc: self, superview: avatarView, completion: { image in
                self.updateUser?.model.profileImageURL = nil
                self.updateUser?.model.profileImageEdit = image
                self.enabledSaveBtn()
                self.avatarView.updateUI(self.updateUser)
            })
        }
    }
}

//MARK: - UITextFieldDelegate

extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text,
           !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            text != updateUser?.name {
            nameTxt = text
            
        } else {
            nameTxt = ""
        }
        
        if nameTxt == "" {
            textField.text = updateUser?.name
        }
        
        enabledSaveBtn()
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

extension EditProfileVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        var yOffset: CGFloat = 0
        
        if textView == bioView.textView {
            if textView.text == "Bio" && bioTxt == "" {
                textView.textColor = .black
                textView.text = ""
            }
            
            yOffset = self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom
        }
        
        DispatchQueue.main.async {
            let offset = CGPoint(x: 0.0, y: yOffset)
            self.scrollView.setContentOffset(offset, animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == bioView.textView {
            var txt = ""
            if textView.text == "" {
                textView.textColor = .placeholderText
                textView.text = "Bio"
                txt = textView.text
            }
            
            if txt == "", let text = textView.text,
               !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                bioTxt = text
                updateUser?.model.bio = bioTxt
                
            } else {
                bioTxt = ""
                bioCount = "0/400"
                bioView.countLbl.text = bioCount
                updateUser?.model.bio = nil
            }
            
            if bioTxt != "" {
                textView.text = bioTxt
            }
        }
        
        enabledSaveBtn()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == bioView.textView {
            guard let txt = textView.text, let range = Range(range, in: txt) else {
                return false
            }
            let sub = txt[range]
            let count = txt.count - sub.count + text.count
            
            bioCount = "\(count)/400"
            bioView.countLbl.text = bioCount
            
            return count < 400
        }
        
        return false
    }
}
