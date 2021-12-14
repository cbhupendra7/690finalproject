//
//  PostImagesCVCell.swift
//  RollingRobots
//
//  Created by Thanh Hoang on 24/09/2021.
//

import UIKit

protocol PostImagesCVCellDelegate: AnyObject {
    func deleteDidTap(_ cell: PostImagesCVCell)
}

class PostImagesCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "PostImagesCVCell"
    weak var delegate: PostImagesCVCellDelegate?
    
    let containerView = UIView()
    let featuredImgView = UIImageView()
    let deleteBtn = ButtonAnimation()
    
    let desView = UIView()
    let desLbl = UILabel()
    let desTV = CustomTV()
    
    var commentTxt = ""
    var vc: PostProjectVC!
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configures

extension PostImagesCVCell {
    
    private func configureCell() {
        //TODO: - ContainerView
        let playerW: CGFloat = 180 * 16 / 9
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalToConstant: playerW).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        //TODO: - FeaturedImgView
        featuredImgView.clipsToBounds = true
        featuredImgView.contentMode = .scaleAspectFill
        featuredImgView.isHidden = true
        containerView.addSubview(featuredImgView)
        featuredImgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - DeleteBtn
        let sp: CGFloat = 7.0
        deleteBtn.clipsToBounds = true
        deleteBtn.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        deleteBtn.setImage(UIImage(named: "icon-trash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteBtn.layer.cornerRadius = 10.0
        deleteBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        deleteBtn.tintColor = .white
        deleteBtn.tag = 1
        deleteBtn.delegate = self
        deleteBtn.contentEdgeInsets = UIEdgeInsets(top: sp, left: sp, bottom: sp, right: sp)
        containerView.addSubview(deleteBtn)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - DescriptionView
        desView.clipsToBounds = true
        desView.backgroundColor = .white
        desView.translatesAutoresizingMaskIntoConstraints = false
        desView.widthAnchor.constraint(equalToConstant: playerW).isActive = true
        desView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        //TODO: - Title
        desLbl.font = UIFont(name: FontName.ppBold, size: 15.0)
        desLbl.text = "DESCRIPTION"
        desView.addSubview(desLbl)
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - DescriptionTV
        desTV.font = UIFont(name: FontName.ppRegular, size: 15.0)
        desTV.showsVerticalScrollIndicator = false
        desTV.showsHorizontalScrollIndicator = false
        desTV.clipsToBounds = true
        desTV.setContentOffset(CGPoint(x: 5.0, y: 5.0), animated: false)
        desTV.textColor = .placeholderText
        desTV.backgroundColor = UIColor.placeholderText.withAlphaComponent(0.05)
        desTV.text = "Description"
        desTV.delegate = self
        desTV.layer.cornerRadius = 10.0
        desTV.addDoneBtn(target: self, selector: #selector(endTV))
        desTV.translatesAutoresizingMaskIntoConstraints = false
        desTV.widthAnchor.constraint(equalToConstant: playerW).isActive = true
        desTV.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = UIStackView()
        stackView.spacing = 0.0
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(desView)
        stackView.addArrangedSubview(desTV)
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Video
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            featuredImgView.topAnchor.constraint(equalTo: containerView.topAnchor),
            featuredImgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            featuredImgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            featuredImgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            deleteBtn.widthAnchor.constraint(equalToConstant: 40.0),
            deleteBtn.heightAnchor.constraint(equalToConstant: 40.0),
            deleteBtn.topAnchor.constraint(equalTo: containerView.topAnchor),
            deleteBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            desLbl.leadingAnchor.constraint(equalTo: desView.leadingAnchor),
            desLbl.centerYAnchor.constraint(equalTo: desView.centerYAnchor),
        ])
    }
    
    @objc private func endTV() {
        desTV.resignFirstResponder()
    }
}

//MARK: - ButtonAnimationDelegate

extension PostImagesCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Delete
            delegate?.deleteDidTap(self)
        }
    }
}

//MARK: - UITextViewDelegate

extension PostImagesCVCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" && commentTxt == "" {
            textView.textColor = .black
            textView.text = ""
        }
        
        DispatchQueue.main.async {
            let offset = CGPoint(x: 0.0, y: self.vc.scrollView.contentSize.height - self.vc.scrollView.bounds.height + self.vc.scrollView.contentInset.bottom)
            self.vc.scrollView.setContentOffset(offset, animated: true)
        }
        
        if let indexPath = vc.imagesView.collectionView.indexPath(for: self) {
            vc.imagesView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        var txt = ""
        if textView.text == "" {
            textView.textColor = .placeholderText
            textView.text = "Description"
            txt = textView.text
        }
        
        if txt == "", let text = textView.text,
           !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            commentTxt = text
            
            if let indexPath = vc.imagesView.collectionView.indexPath(for: self) {
                vc.updatePr.posts[indexPath.item].model.description = commentTxt
            }
            
        } else {
            commentTxt = ""
            textView.textColor = .placeholderText
            textView.text = "Description"
            
            if let indexPath = vc.imagesView.collectionView.indexPath(for: self) {
                vc.updatePr.posts[indexPath.item].model.description = nil
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == desTV {
            guard let txt = textView.text, let range = Range(range, in: txt) else {
                return false
            }
            let sub = txt[range]
            let count = txt.count - sub.count + text.count
            
            return count < 400
        }
        
        return false
    }
}
