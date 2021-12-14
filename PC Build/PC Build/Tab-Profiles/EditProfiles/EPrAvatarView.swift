//
//  EPrAvatarView.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class EPrAvatarView: UIView {
    
    //MARK: - Properties
    let coverView = UIView()
    let coverImageView = UIImageView()
    let avatarView = UIView()
    let avatarImgView = UIImageView()
    
    let editView = UIView()
    let editAvatarBtn = ButtonAnimation()
    
    var coverHeightLayout: NSLayoutConstraint!
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension EPrAvatarView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CoverView
        let coverH: CGFloat = screenWidth*9/16
        coverView.clipsToBounds = true
        coverView.backgroundColor = UIColor(hex: 0x3F7BEF)
        addSubview(coverView)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverHeightLayout = coverView.heightAnchor.constraint(equalToConstant: coverH)
        coverHeightLayout.isActive = true
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.image = nil
        coverImageView.isHidden = true
        coverView.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - AvatarView
        let avatarW: CGFloat = coverH*0.6
        avatarView.backgroundColor = .white
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = avatarW/2
        insertSubview(avatarView, aboveSubview: coverView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - AvatarIMGView
        let imgViewW: CGFloat = avatarW*0.93
        avatarImgView.contentMode = .scaleAspectFill
        avatarImgView.clipsToBounds = true
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.cornerRadius = imgViewW/2.0
        avatarImgView.image = UIImage(named: "icon-avatar")
        insertSubview(avatarImgView, aboveSubview: avatarView)
        avatarImgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - EditView
        let editW: CGFloat = avatarW*0.24
        editView.backgroundColor = .white
        editView.clipsToBounds = true
        editView.layer.cornerRadius = editW/2
        insertSubview(editView, aboveSubview: avatarImgView)
        editView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - EditAvatar
        let edAvatarW: CGFloat = editW*0.85
        let edAvatarX: CGFloat = (editW - edAvatarW)/2
        editAvatarBtn.frame = CGRect(x: edAvatarX, y: edAvatarX, width: edAvatarW, height: edAvatarW)
        editAvatarBtn.clipsToBounds = true
        editAvatarBtn.backgroundColor = .white
        editAvatarBtn.layer.cornerRadius = edAvatarW/2.0
        editAvatarBtn.layer.borderWidth = 2.0
        editAvatarBtn.layer.borderColor = UIColor(hex: 0x3F7BEF).cgColor
        editAvatarBtn.contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        editAvatarBtn.setImage(UIImage(named: "icon-camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        editAvatarBtn.tintColor = UIColor(hex: 0x3F7BEF)
        editAvatarBtn.tag = 1
        editView.addSubview(editAvatarBtn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: topAnchor),
            coverView.widthAnchor.constraint(equalToConstant: screenWidth),
            coverView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            coverImageView.topAnchor.constraint(equalTo: coverView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverView.bottomAnchor),
            
            avatarView.widthAnchor.constraint(equalToConstant: avatarW),
            avatarView.heightAnchor.constraint(equalToConstant: avatarW),
            avatarView.centerYAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            avatarImgView.widthAnchor.constraint(equalToConstant: imgViewW),
            avatarImgView.heightAnchor.constraint(equalToConstant: imgViewW),
            avatarImgView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarImgView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            editView.widthAnchor.constraint(equalToConstant: editW),
            editView.heightAnchor.constraint(equalToConstant: editW),
            editView.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: -5.0),
            editView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: -5.0),
        ])
    }
    
    func updateUI(_ user: User?) {
        if let link = user?.profileImageURL {
            DownloadImage.shared.downloadImage(link: link) { image in
                self.avatarImgView.image = image
            }
        }
        
        if let image = user?.profileImageEdit {
            avatarImgView.image = image
        }
    }
}
