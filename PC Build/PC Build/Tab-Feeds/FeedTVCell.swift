//
//  FeedTVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit

protocol FeedTVCellDelegate: AnyObject {
    func dotsDidTap(_ cell: FeedTVCell)
    func likeDidTap(_ cell: FeedTVCell)
    func savedDidTap(_ cell: FeedTVCell)
}

class FeedTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "FeedTVCell"
    weak var delegate: FeedTVCellDelegate?
    
    let containerView = UIView()
    let topView = UIView()
    let avatarImgView = UIImageView()
    let nameLbl = UILabel()
    let createdTimeLbl = UILabel()
    let dotsBtn = ButtonAnimation()
    let prImageView = UIImageView()
    let likeView = UIView()
    let desLbl = UILabel()
    
    let likeBtn = ButtonAnimation()
    let likeCountLbl = UILabel()
    let savedBtn = ButtonAnimation()
    
    var isLike = false {
        didSet {
            let color = isLike ? UIColor(hex: 0x3F7BEF) : UIColor(hex: 0xD4D4D4)
            likeBtn.tintColor = color
        }
    }
    
    var isSaved = false {
        didSet {
            let color = isSaved ? UIColor(hex: 0x3F7BEF) : UIColor(hex: 0xD4D4D4)
            savedBtn.tintColor = color
        }
    }
    
    var user: User! {
        didSet {
            nameLbl.text = user.name == "" ? "New User" : user.name
            
            if let link = user.profileImageURL {
                DownloadImage.shared.downloadImage(link: link) { image in
                    self.avatarImgView.image = image
                }
            }
        }
    }
    
    var model: Project! {
        didSet {
            desLbl.text = model.description?.trimmingCharacters(in: .whitespacesAndNewlines)
            desLbl.isHidden = model.description == nil

            if let created = model.createdDate {
                let date = created.dateValue()
                let formatter = DateFormatter()

                formatter.dateFormat = "yyyy/MM/dd"
                createdTimeLbl.text = formatter.string(from: date)
            }
            
            if let link = model.posts.first?.imageURL {
                DownloadImage.shared.downloadImage(link: link) { image in
                    self.prImageView.image = image
                }
            }
        }
    }
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImgView.image = UIImage(named: "icon-avatar")
        prImageView.image = nil
    }
    
    var isTouch: Bool = false {
        didSet {
            updateAnimation(self, isEvent: isTouch, alpha: 0.8)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isTouch { isTouch = true }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isTouch { isTouch = false }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouch = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let superview = superview {
            let location = touch.location(in: superview)
            isTouch = frame.contains(location)
        }
    }
}

//MARK: - Configures

extension FeedTVCell {
    
    private func configureCell() {
        //TODO: - CollectionView
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10.0
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        containerView.layer.shadowRadius = 2.0
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TopView
        topView.clipsToBounds = true
        topView.backgroundColor = .white
        topView.layer.cornerRadius = 10.0
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 55.0).isActive = true
        
        //TODO: - ImageView
        let avatarH: CGFloat = 40.0
        avatarImgView.clipsToBounds = true
        avatarImgView.layer.cornerRadius = avatarH/2
        avatarImgView.image = UIImage(named: "icon-avatar")
        avatarImgView.contentMode = .scaleAspectFit
        avatarImgView.translatesAutoresizingMaskIntoConstraints = false
        avatarImgView.widthAnchor.constraint(equalToConstant: avatarH).isActive = true
        avatarImgView.heightAnchor.constraint(equalToConstant: avatarH).isActive = true
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppBold, size: 17.0)
        nameLbl.text = ""
        nameLbl.textColor = .black
        
        //TODO: - CreatedTime
        createdTimeLbl.font = UIFont(name: FontName.ppRegular, size: 15.0)
        createdTimeLbl.text = ""
        createdTimeLbl.textColor = .gray
        
        //TODO: - UIStackView
        let nameSV = UIStackView(arrangedSubviews: [nameLbl, createdTimeLbl])
        nameSV.spacing = 0.0
        nameSV.axis = .vertical
        nameSV.distribution = .fill
        nameSV.alignment = .leading
        
        //TODO: - UIStackView
        let avaSV = UIStackView(arrangedSubviews: [avatarImgView, nameSV])
        avaSV.spacing = 10.0
        avaSV.axis = .horizontal
        avaSV.distribution = .fill
        avaSV.alignment = .top
        topView.addSubview(avaSV)
        avaSV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ThreeDots
        let dotsH: CGFloat = 25.0
        dotsBtn.contentEdgeInsets = .zero
        dotsBtn.setImage(UIImage(named: "icon-threeDots"), for: .normal)
        dotsBtn.delegate = self
        dotsBtn.tag = 1
        dotsBtn.backgroundColor = .clear
        topView.addSubview(dotsBtn)
        dotsBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - RecentsView
        let newsFeedH: CGFloat = ((screenWidth-60)/3)*2 + 5
        prImageView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        prImageView.clipsToBounds = true
        prImageView.contentMode = .scaleAspectFill
        prImageView.image = nil
        prImageView.layer.cornerRadius = 16.0
        prImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.05).cgColor
        prImageView.layer.borderWidth = 0.5
        prImageView.translatesAutoresizingMaskIntoConstraints = false
        prImageView.widthAnchor.constraint(equalToConstant: screenWidth-50).isActive = true
        prImageView.heightAnchor.constraint(equalToConstant: newsFeedH).isActive = true
        
        //TODO: - LikeView
        likeView.clipsToBounds = true
        likeView.backgroundColor = .clear
        likeView.translatesAutoresizingMaskIntoConstraints = false
        likeView.widthAnchor.constraint(equalToConstant: screenWidth-50).isActive = true
        likeView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //TODO: - LikeBtn
        let likeW: CGFloat = 25.0
        likeBtn.clipsToBounds = true
        likeBtn.setImage(UIImage(named: "icon-like")?.withRenderingMode(.alwaysTemplate), for: .normal)
        likeBtn.tintColor = UIColor(hex: 0xD4D4D4)
        likeBtn.tag = 2
        likeBtn.delegate = self
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.widthAnchor.constraint(equalToConstant: likeW).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: likeW).isActive = true
        
        //TODO: - LikeCountLbl
        likeCountLbl.font = UIFont(name: FontName.ppRegular, size: 17.0)
        likeCountLbl.textColor = .gray
        likeCountLbl.text = ""
        
        //TODO: - SavedBtn
        savedBtn.clipsToBounds = true
        savedBtn.setImage(UIImage(named: "icon-saved")?.withRenderingMode(.alwaysTemplate), for: .normal)
        savedBtn.tintColor = UIColor(hex: 0xD4D4D4)
        savedBtn.tag = 3
        savedBtn.delegate = self
        savedBtn.translatesAutoresizingMaskIntoConstraints = false
        savedBtn.widthAnchor.constraint(equalToConstant: likeW).isActive = true
        savedBtn.heightAnchor.constraint(equalToConstant: likeW).isActive = true
        
        //TODO: - UIStackView
        let likeSV = UIStackView()
        likeSV.spacing = 15.0
        likeSV.axis = .horizontal
        likeSV.distribution = .fill
        likeSV.alignment = .center
        likeSV.addArrangedSubview(likeBtn)
        likeSV.setCustomSpacing(5.0, after: likeBtn)
        likeSV.addArrangedSubview(likeCountLbl)
        likeSV.addArrangedSubview(savedBtn)
        likeView.addSubview(likeSV)
        likeSV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Description
        desLbl.font = UIFont(name: FontName.ppRegular, size: 17.0)
        desLbl.text = ""
        desLbl.textColor = .black
        desLbl.numberOfLines = 4
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        desLbl.widthAnchor.constraint(equalToConstant: screenWidth-50).isActive = true
        
        //TODO: - UIStackView
        let stackView = UIStackView()
        stackView.spacing = 0.0
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(prImageView)
        stackView.addArrangedSubview(likeView)
        stackView.addArrangedSubview(desLbl)
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            avaSV.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            avaSV.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5.0),
            avaSV.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -40.0),
            
            dotsBtn.widthAnchor.constraint(equalToConstant: dotsH),
            dotsBtn.heightAnchor.constraint(equalToConstant: dotsH),
            dotsBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            dotsBtn.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10.0),
            
            likeSV.centerYAnchor.constraint(equalTo: likeView.centerYAnchor),
            likeSV.leadingAnchor.constraint(equalTo: likeView.leadingAnchor),
        ])
    }
}

//MARK: - ButtonAnimationDelegate

extension FeedTVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Threes dots
            delegate?.dotsDidTap(self)
            
        } else if sender.tag == 2 { //Like
            delegate?.likeDidTap(self)
            
        } else if sender.tag == 3 { //Saved
            delegate?.savedDidTap(self)
        }
    }
}
