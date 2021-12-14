//
//  EPrContainerView.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class EPrContainerView: UIView {
    
    //MARK: - Properties
    let avatarView = EPrAvatarView()
    let nameView = EPrNameView()
    let bioView = EPrBioView()
    let stackView = UIStackView()
    
    var coverH: CGFloat = screenWidth * 9 / 16
    var avatarH: CGFloat {
        return coverH + (coverH*0.6)/2 + 20
    }
    var nameH: CGFloat = 40 + 60
    var bioH: CGFloat = 40 + 150
    
    var avatarHeightLayout: NSLayoutConstraint!
    
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

extension EPrContainerView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - AvatarView
        avatarView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        avatarHeightLayout = avatarView.heightAnchor.constraint(equalToConstant: avatarH)
        avatarHeightLayout.isActive = true
        
        //TODO: - NameView
        nameView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: nameH).isActive = true
        
        //TODO: - BioView
        bioView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        bioView.heightAnchor.constraint(equalToConstant: bioH).isActive = true
        
        //TODO: - UIStackView
        stackView.spacing = 0.0
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.addArrangedSubview(avatarView)
        stackView.addArrangedSubview(nameView)
        stackView.addArrangedSubview(bioView)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
