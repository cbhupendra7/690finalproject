//
//  PrProjectsView.swift
//  PC Build
//
//  Created by Thanh Hoang on 19/11/2021.
//

import UIKit

class PrProjectsView: UIView {
    
    //MARK: - Properties
    var segmentedControl: UISegmentedControl!
    let tableView = UITableView(frame: .zero, style: .plain)
    
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

extension PrProjectsView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SegmentedControl
        segmentedControl = UISegmentedControl(items: ["Posts", "Liked", "Saved"])
        segmentedControl.selectedSegmentIndex = 0
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Posts CollectionView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 90.0
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(PrProjectTVCell.self, forCellReuseIdentifier: PrProjectTVCell.id)
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10.0),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
