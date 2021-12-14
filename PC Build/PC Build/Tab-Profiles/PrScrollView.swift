//
//  PrScrollView.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class PrScrollView: UIScrollView {
    
    //MARK: - Properties
    let containerView = PrContainerView()
    
    var cvHeightLayout: NSLayoutConstraint!
    var cvTopLayout: NSLayoutConstraint!
    
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

extension PrScrollView {
    
    func setupViews(_ vc: ProfileVC, dl: UIScrollViewDelegate) {
        delegate = dl
        vc.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ContainerView
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        cvHeightLayout = containerView.heightAnchor.constraint(equalToConstant: 0.0)
        cvHeightLayout.priority = UILayoutPriority.defaultLow
        cvHeightLayout.isActive = true
        
        cvTopLayout = containerView.topAnchor.constraint(equalTo: topAnchor)
        cvTopLayout.isActive = true
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: vc.view.topAnchor),
            bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: vc.view.widthAnchor),
        ])
    }
}
