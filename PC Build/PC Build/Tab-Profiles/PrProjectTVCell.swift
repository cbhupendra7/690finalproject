//
//  PrProjectTVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit

class PrProjectTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "PrProjectTVCell"
    
    let prImageView = UIImageView()
    let titleLbl = UILabel()
    let desLbl = UILabel()
    let createdTimeLbl = UILabel()
    
    var model: Project! {
        didSet {
            titleLbl.text = model.title
            
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
        prImageView.image = nil
    }
}

//MARK: - Configures

extension PrProjectTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .white
        
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        selectedBackgroundView = selectedView
        
        //TODO: - ImageView
        let prImgH: CGFloat = 70.0
        prImageView.clipsToBounds = true
        prImageView.layer.cornerRadius = 10
        prImageView.image = nil
        prImageView.contentMode = .scaleAspectFill
        contentView.addSubview(prImageView)
        prImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CreatedTime
        createdTimeLbl.font = UIFont(name: FontName.ppRegular, size: 15.0)
        createdTimeLbl.text = ""
        createdTimeLbl.textColor = .gray
        createdTimeLbl.textAlignment = .right
        contentView.addSubview(createdTimeLbl)
        createdTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NameLbl
        titleLbl.font = UIFont(name: FontName.ppBold, size: 17.0)
        titleLbl.text = ""
        titleLbl.textColor = .black
        contentView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Description
        desLbl.font = UIFont(name: FontName.ppRegular, size: 16.0)
        desLbl.text = ""
        desLbl.textColor = .black
        desLbl.numberOfLines = 2
        contentView.addSubview(desLbl)
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            prImageView.widthAnchor.constraint(equalToConstant: prImgH),
            prImageView.heightAnchor.constraint(equalToConstant: prImgH),
            prImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            prImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            createdTimeLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            createdTimeLbl.topAnchor.constraint(equalTo: prImageView.topAnchor),

            titleLbl.topAnchor.constraint(equalTo: prImageView.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: prImageView.trailingAnchor, constant: 10.0),

            desLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5.0),
            desLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            desLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
        ])
        
        let titleTrail = titleLbl.trailingAnchor.constraint(lessThanOrEqualTo: createdTimeLbl.leadingAnchor, constant: -5.0)
        titleTrail.priority = .defaultLow
        titleTrail.isActive = true
    }
}
