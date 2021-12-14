//
//  EmailTVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

class EmailTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "EmailTVCell"
    
    let textField = UITextField()
    
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

extension EmailTVCell {
    
    private func configureCell() {
        textField.configureFromTF("Email", imgName: "icon-email")
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
