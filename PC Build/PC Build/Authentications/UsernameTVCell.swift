//
//  UsernameTVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

class UsernameTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "UsernameTVCell"
    
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

extension UsernameTVCell {
    
    private func configureCell() {
        textField.configureFromTF("Name (min 6 characters)", imgName: "icon-username")
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
