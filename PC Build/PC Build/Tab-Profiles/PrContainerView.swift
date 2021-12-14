//
//  PrContainerView.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class PrContainerView: UIView {
    
    //MARK: - Properties
    let avatarView = PrAvatarView()
    let nameLbl = UILabel()
    let bioLbl = UILabel()
    let projectsView = PrProjectsView()
    let stackView = UIStackView()
    
    var avatarHeightLayout: NSLayoutConstraint!
    
    var coverH: CGFloat = screenWidth * 9 / 16
    var avatarH: CGFloat {
        return coverH + (coverH*0.6)/2 + 15
    }
    var projectH: CGFloat {
        return 35 + screenWidth
    }
    
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

extension PrContainerView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        
        //TODO: - AvatarView
        avatarView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        avatarHeightLayout = avatarView.heightAnchor.constraint(equalToConstant: avatarH)
        avatarHeightLayout.isActive = true
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppBold, size: 25.0)
        nameLbl.textAlignment = .center
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        
        //TODO: - BioLbl
        bioLbl.font = UIFont(name: FontName.ppRegular, size: 14.0)
        bioLbl.textAlignment = .center
        bioLbl.textColor = .gray
        bioLbl.numberOfLines = 0
        bioLbl.translatesAutoresizingMaskIntoConstraints = false
        bioLbl.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        
        //TODO: - ProjectsView
        projectsView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        projectsView.heightAnchor.constraint(equalToConstant: projectH).isActive = true
        
        //TODO: - UIStackView
        stackView.spacing = 20.0
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.addArrangedSubview(avatarView)
        stackView.setCustomSpacing(0.0, after: avatarView)
        stackView.addArrangedSubview(nameLbl)
        stackView.addArrangedSubview(bioLbl)
        stackView.addArrangedSubview(projectsView)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: screenWidth),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20.0),
        ])
    }
    
    func updateUI(_ user: User) {
        avatarView.updateUI(user)
        
        nameLbl.text = user.name
        bioLbl.text = user.bio
        bioLbl.isHidden = user.bio == nil
    }
}
