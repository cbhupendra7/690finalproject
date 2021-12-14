//
//  PostAddView.swift
//  RollingRobots
//
//  Created by Thanh Hoang on 24/09/2021.
//

import UIKit

class PostAddView: UIView {
    
    //MARK: - Properties
    let titleView = UIView()
    let addView = UIView()
    let photoBtn = ButtonAnimation()
    
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

extension PostAddView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .systemGroupedBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleView
        titleView.clipsToBounds = true
        titleView.backgroundColor = .systemGroupedBackground
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        
        //TODO: - AddView
        addView.clipsToBounds = true
        addView.backgroundColor = .systemGroupedBackground
        addView.translatesAutoresizingMaskIntoConstraints = false
        addView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addView.heightAnchor.constraint(equalToConstant: 65.0).isActive = true
        
        //TODO: - Photo
        let btnW: CGFloat = (screenWidth - 60)/2
        let btnH: CGFloat = 50.0
        let btnAtt = [
            NSAttributedString.Key.font : UIFont(name: FontName.ppBold, size: 17.0)!,
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        let photoAttr = NSMutableAttributedString(string: "Add Photo", attributes: btnAtt)
        photoBtn.setAttributedTitle(photoAttr, for: .normal)
        photoBtn.backgroundColor = UIColor(hex: 0x3F7BEF)
        photoBtn.clipsToBounds = true
        photoBtn.layer.cornerRadius = btnH/2
        photoBtn.tag = 1
        addView.addSubview(photoBtn)
        photoBtn.translatesAutoresizingMaskIntoConstraints = false
        photoBtn.widthAnchor.constraint(equalToConstant: btnW).isActive = true
        photoBtn.heightAnchor.constraint(equalToConstant: btnH).isActive = true
        
        //TODO: - UIStackView
        let stackView = UIStackView(arrangedSubviews: [titleView, addView])
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
            
            photoBtn.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
            photoBtn.topAnchor.constraint(equalTo: addView.topAnchor, constant: 5.0),
        ])
    }
}
