//
//  PostDescriptionView.swift
//  RollingRobots
//
//  Created by Thanh Hoang on 24/09/2021.
//

import UIKit

class PostDescriptionView: UIView {
    
    //MARK: - Properties
    let titleView = UIView()
    let titleLbl = UILabel()
    let countLbl = UILabel()
    let desView = UIView()
    let textView = CustomTV()
    
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

extension PostDescriptionView {
    
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
        titleLbl.text = "DESCRIPTION"
        titleView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CountLbl
        countLbl.font = UIFont(name: FontName.ppBold, size: 17.0)
        countLbl.textColor = .gray
        countLbl.textAlignment = .right
        countLbl.text = "0/400"
        titleView.addSubview(countLbl)
        countLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - DesView
        desView.clipsToBounds = true
        desView.backgroundColor = .white
        desView.translatesAutoresizingMaskIntoConstraints = false
        desView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        desView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        //TODO: - TextView
        textView.setupTV()
        textView.text = "Description"
        desView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UIStackView
        let stackView = UIStackView(arrangedSubviews: [titleView, desView])
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
            
            countLbl.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20.0),
            countLbl.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            textView.topAnchor.constraint(equalTo: desView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: desView.leadingAnchor, constant: 15.0),
            textView.trailingAnchor.constraint(equalTo: desView.trailingAnchor, constant: -15.0),
            textView.bottomAnchor.constraint(equalTo: desView.bottomAnchor),
        ])
    }
}
