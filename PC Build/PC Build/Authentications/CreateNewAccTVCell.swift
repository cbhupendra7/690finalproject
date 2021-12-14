//
//  CreateNewAccTVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

class CreateNewAccTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "CreateNewAccTVCell"
    
    let signUpBtn = ButtonAnimation()
    private let signUpTxt = "CREATE NEW ACCOUNT"
    
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

extension CreateNewAccTVCell {
    
    private func configureCell() {
        let att = [
            NSAttributedString.Key.font : UIFont(name: FontName.ppBold, size: 18.0)!,
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        let attr = NSMutableAttributedString(string: "Sign Up", attributes: att)
        signUpBtn.setAttributedTitle(attr, for: .normal)
        signUpBtn.backgroundColor = UIColor(hex: 0x3F7BEF)
        signUpBtn.clipsToBounds = true
        signUpBtn.layer.cornerRadius = 50/2
        signUpBtn.layer.borderColor = UIColor.clear.cgColor
        signUpBtn.layer.borderWidth = 1.0
        signUpBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        contentView.addSubview(signUpBtn)
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signUpBtn.widthAnchor.constraint(equalToConstant: screenWidth*0.9),
            signUpBtn.heightAnchor.constraint(equalToConstant: 50.0),
            signUpBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            signUpBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
