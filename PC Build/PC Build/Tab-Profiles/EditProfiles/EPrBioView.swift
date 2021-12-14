//
//  EPrBioView.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class EPrBioView: UIView {
    
    //MARK: - Properties
    let titleView = UIView()
    let titleLbl = UILabel()
    let countLbl = UILabel()
    let bioView = UIView()
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

extension EPrBioView {
    
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
        titleLbl.text = "BIO"
        titleView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CountLbl
        countLbl.font = UIFont(name: FontName.ppBold, size: 17.0)
        countLbl.textColor = .gray
        countLbl.textAlignment = .right
        countLbl.text = "0/400"
        titleView.addSubview(countLbl)
        countLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Quote
        bioView.clipsToBounds = true
        bioView.backgroundColor = .white
        bioView.translatesAutoresizingMaskIntoConstraints = false
        bioView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        bioView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        //TODO: - TextView
        textView.setupTV()
        textView.text = "Bio"
        bioView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UIStackView
        let stackView = UIStackView(arrangedSubviews: [titleView, bioView])
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
            
            textView.topAnchor.constraint(equalTo: bioView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: bioView.leadingAnchor, constant: 15.0),
            textView.trailingAnchor.constraint(equalTo: bioView.trailingAnchor, constant: -15.0),
            textView.bottomAnchor.constraint(equalTo: bioView.bottomAnchor),
        ])
    }
}
