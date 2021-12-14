//
//  EPrNameView.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class EPrNameView: UIView {
    
    //MARK: - Properties
    let titleView = UIView()
    let titleLbl = UILabel()
    let textField = ProjectTitleTF()
    
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

extension EPrNameView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleView
        titleView.clipsToBounds = true
        titleView.backgroundColor = .systemGroupedBackground
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        //TODO: - Title
        titleLbl.font = UIFont(name: FontName.ppBold, size: 17.0)
        titleLbl.text = "NAME"
        titleView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TextFiew
        textField.font = UIFont(name: FontName.ppRegular, size: 17.0)
        textField.clipsToBounds = true
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = UIStackView(arrangedSubviews: [titleView, textField])
        stackView.spacing = 0.0
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLbl.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20.0),
            titleLbl.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
        ])
    }
}
