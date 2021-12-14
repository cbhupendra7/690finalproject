//
//  ProjectCVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit

class ProjectCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "ProjectCVCell"
    
    let containerView = UIView()
    let prImageView = UIImageView()
    let createdTimeLbl = UILabel()
    let desLbl = UILabel()
    
    private var cvHeightConstraint: NSLayoutConstraint!
    
    var post: Post! {
        didSet {
            if let createdDate = post.createdDate {
                let date = createdDate.dateValue()
                let formatter = DateFormatter()

                formatter.dateFormat = "yyyy/MM/dd"
                createdTimeLbl.text = formatter.string(from: date)
            }
            
            if let link = post.imageURL {
                DownloadImage.shared.downloadImage(link: link) { image in
                    self.prImageView.image = image
                }
            }
            
            containerView.isHidden = post.imageURL == nil
            desLbl.text = post.description
        }
    }
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prImageView.image = nil
    }
}

//MARK: - Configures

extension ProjectCVCell {
    
    private func configureCell() {
        //TODO: - ContainerView
        let prW: CGFloat = screenWidth - 40
        let prH: CGFloat = prW * 9/16
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 16.0
        containerView.backgroundColor = .black
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalToConstant: prW).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: prH).isActive = true
        
        //TODO: - ImageView
        prImageView.frame = CGRect(x: 0.0, y: 0.0, width: prW, height: prH)
        prImageView.clipsToBounds = true
        prImageView.contentMode = .scaleAspectFill
        prImageView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        prImageView.image = nil
        containerView.addSubview(prImageView)
        
        //TODO: - TitleLbl
        createdTimeLbl.font = UIFont(name: FontName.ppRegular, size: 15.0)
        createdTimeLbl.text = ""
        createdTimeLbl.textColor = .gray
        
        //TODO: - Description
        desLbl.font = UIFont(name: FontName.ppRegular, size: 17.0)
        desLbl.text = ""
        desLbl.textColor = .black
        desLbl.numberOfLines = 0
        
        //TODO: - UIStackView
        let sv = UIStackView()
        sv.alignment = .leading
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 10.0
        sv.addArrangedSubview(containerView)
        sv.setCustomSpacing(5.0, after: containerView)
        sv.addArrangedSubview(createdTimeLbl)
        sv.addArrangedSubview(desLbl)
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: contentView.topAnchor),
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            sv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            sv.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
