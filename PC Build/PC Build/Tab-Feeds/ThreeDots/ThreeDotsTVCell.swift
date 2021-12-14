//
//  ThreeDotsTVCell.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit

class ThreeDotsTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "ThreeDotsTVCell"
    
    let iconImgView = UIImageView()
    let titleLbl = UILabel()
    
    var model: ThreeDotsModel! {
        didSet {
            iconImgView.image = model.image
            titleLbl.text = model.title
        }
    }
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ThreeDotsTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        selectedBackgroundView = selectedView
        
        //TODO: - Icon
        let iconH: CGFloat = 20.0
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.clipsToBounds = true
        iconImgView.image = nil
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.widthAnchor.constraint(equalToConstant: iconH).isActive = true
        iconImgView.heightAnchor.constraint(equalToConstant: iconH).isActive = true
        
        //TODO: - Title
        titleLbl.font = UIFont(name: FontName.ppRegular, size: 17.0)
        titleLbl.text = ""
        titleLbl.textColor = .black
        
        let sv = UIStackView(arrangedSubviews: [iconImgView, titleLbl])
        sv.spacing = 10.0
        sv.alignment = .center
        sv.distribution = .fill
        sv.axis = .horizontal
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
        ])
    }
}
