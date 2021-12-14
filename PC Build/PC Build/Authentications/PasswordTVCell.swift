//
//  PasswordTVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

protocol PasswordTVCellDelegate: AnyObject {
    func passEyeDidTap(_ cell: PasswordTVCell)
}

class PasswordTVCell: UITableViewCell {
    
    //MARK: - Properties
    weak var delegate: PasswordTVCellDelegate?
    static let id = "PasswordTVCell"
    
    let textField = UITextField()
    let rightImgView = UIImageView()
    
    var isShow = false {
        didSet {
            rightImgView.image = UIImage(named: isShow ? "icon-eyeOff" : "icon-eyeOn")
            textField.isSecureTextEntry = !isShow
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

extension PasswordTVCell {
    
    private func configureCell() {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //let passPlTxt = "●●●●●●"
        textField.configureFromTFLeftRightView("Password (min 8 characters)", imgName: "icon-password", rightImgView: rightImgView)
        textField.isSecureTextEntry = true
        containerView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            textField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(passEyeDidTap))
        rightImgView.addGestureRecognizer(tap)
    }
    
    @objc private func passEyeDidTap() {
        delegate?.passEyeDidTap(self)
    }
}
