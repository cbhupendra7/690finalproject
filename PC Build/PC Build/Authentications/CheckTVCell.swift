//
//  CheckTVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

class CheckTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "CheckTVCell"
    
    let checkView = UIView()
    let checkImageView = UIImageView()
    let titleLbl = UILabel()
    
    var isCheck = false {
        didSet {
            checkImageView.isHidden = !isCheck
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
}

//MARK: - Configures

extension CheckTVCell {
    
    private func configureCell() {
        //TODO: - CheckView
        let checkW: CGFloat = 25.0
        checkView.backgroundColor = .white
        checkView.clipsToBounds = true
        checkView.layer.cornerRadius = 3.0
        checkView.layer.borderColor = UIColor.gray.cgColor
        checkView.layer.borderWidth = 1.0
        contentView.addSubview(checkView)
        checkView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CheckImageView
        checkImageView.frame = CGRect(x: 0.0, y: 0.0, width: checkW, height: checkW)
        checkImageView.clipsToBounds = true
        checkImageView.image = UIImage(named: "icon-check")
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.isHidden = true
        checkView.addSubview(checkImageView)
        
        //TODO: - TitleLbl
        titleLbl.text = """
I would like to receive your newsletter and other promotional information.
"""
        titleLbl.font = UIFont(name: FontName.ppRegular, size: 15.0)
        titleLbl.textColor = .black
        titleLbl.numberOfLines = 0
        contentView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        let sp = (screenWidth-(screenWidth*0.9))/2
        NSLayoutConstraint.activate([
            checkView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            checkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sp),
            checkView.widthAnchor.constraint(equalToConstant: checkW),
            checkView.heightAnchor.constraint(equalToConstant: checkW),
            
            titleLbl.topAnchor.constraint(equalTo: checkView.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: checkView.trailingAnchor, constant: 8.0),
            titleLbl.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -sp)
        ])
    }
}
