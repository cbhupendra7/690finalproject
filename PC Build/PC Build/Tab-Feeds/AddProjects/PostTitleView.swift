//
//  PostTitleView.swift
//  RollingRobots
//
//  Created by Thanh Hoang on 24/09/2021.
//

import UIKit

class PostTitleView: UIView {
    
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

extension PostTitleView {
    
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
        titleLbl.text = "TITLE"
        titleView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TextFiew
        textField.font = UIFont(name: FontName.ppRegular, size: 17.0)
        textField.clipsToBounds = true
        textField.placeholder = "Post Name"
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
