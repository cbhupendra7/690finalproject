//
//  PostScrollView.swift
//  RollingRobots
//
//  Created by Thanh Hoang on 24/09/2021.
//

import UIKit

class PostScrollView: UIScrollView {
    
    //MARK: - Properties
    let containerView = PostContainerView()
    var cvHeightAnchor: NSLayoutConstraint!
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .white
        contentInsetAdjustmentBehavior = .never
        delaysContentTouches = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true
        bounces = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension PostScrollView {
    
    func setupViews(_ postVC: PostProjectVC, dl: UIScrollViewDelegate) {
        delegate = dl
        postVC.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ContainerView
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        cvHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 0.0)
        cvHeightAnchor.priority = UILayoutPriority.defaultLow
        cvHeightAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: postVC.view.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: postVC.view.safeAreaLayoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: postVC.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: postVC.view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: postVC.view.widthAnchor),
        ])
    }
}
