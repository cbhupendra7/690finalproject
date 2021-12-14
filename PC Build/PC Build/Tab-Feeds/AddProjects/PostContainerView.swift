//
//  PostContainerView.swift
//  RollingRobots
//
//  Created by Thanh Hoang on 24/09/2021.
//

import UIKit

class PostContainerView: UIView {
    
    //MARK: - Properties
    let titleView = PostTitleView()
    let desView = PostDescriptionView()
    let addView = PostAddView()
    let imagesView = PostImagesView()
    let stackView = UIStackView()
    
    let titleH: CGFloat = 40 + 60
    let desH: CGFloat = 40 + 150
    let addH: CGFloat = 5 + 65
    
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

extension PostContainerView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        
        let width: CGFloat = screenWidth
        
        //TODO: - TitleView
        titleView.widthAnchor.constraint(equalToConstant: width).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: titleH).isActive = true
        
        //TODO: - DescriptionView
        desView.widthAnchor.constraint(equalToConstant: width).isActive = true
        desView.heightAnchor.constraint(equalToConstant: desH).isActive = true
        
        //TODO: - AddView
        addView.widthAnchor.constraint(equalToConstant: width).isActive = true
        addView.heightAnchor.constraint(equalToConstant: addH).isActive = true
        
        //TODO: - ImagesView
        imagesView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imagesView.heightAnchor.constraint(equalToConstant: imagesView.height).isActive = true
        
        //TODO: - UIStackView
        stackView.spacing = 0.0
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(desView)
        stackView.addArrangedSubview(addView)
        stackView.addArrangedSubview(imagesView)
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
