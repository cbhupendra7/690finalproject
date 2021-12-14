//
//  ProjectView.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit

class ProjectView: UIView {
    
    //MARK: - Properties
    let avatarImgView = UIImageView()
    let nameLbl = UILabel()
    let createdTimeLbl = UILabel()
    let titleLbl = UILabel()
    let desLbl = UILabel()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension ProjectView {
    
    private func setupViews() {
        //TODO: - ImageView
        let avatarH: CGFloat = 50.0
        avatarImgView.clipsToBounds = true
        avatarImgView.layer.cornerRadius = avatarH/2
        avatarImgView.image = UIImage(named: "icon-avatar")
        avatarImgView.contentMode = .scaleAspectFit
        avatarImgView.translatesAutoresizingMaskIntoConstraints = false
        avatarImgView.widthAnchor.constraint(equalToConstant: avatarH).isActive = true
        avatarImgView.heightAnchor.constraint(equalToConstant: avatarH).isActive = true
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppBold, size: 17.0)
        nameLbl.text = ""
        nameLbl.textColor = .black
        
        //TODO: - CreatedTime
        createdTimeLbl.font = UIFont(name: FontName.ppRegular, size: 15.0)
        createdTimeLbl.text = ""
        createdTimeLbl.textColor = .gray
        
        //TODO: - UIStackView
        let nameSV = UIStackView(arrangedSubviews: [nameLbl, createdTimeLbl])
        nameSV.spacing = 5.0
        nameSV.axis = .vertical
        nameSV.distribution = .fill
        nameSV.alignment = .leading
        
        //TODO: - UIStackView
        let avaSV = UIStackView(arrangedSubviews: [avatarImgView, nameSV])
        avaSV.spacing = 10.0
        avaSV.axis = .horizontal
        avaSV.distribution = .fill
        avaSV.alignment = .center
        
        //TODO: - TitleLbl
        let titleW: CGFloat = screenWidth - 40
        titleLbl.font = UIFont(name: FontName.ppBold, size: 19.0)
        titleLbl.text = ""
        titleLbl.numberOfLines = 0
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.widthAnchor.constraint(equalToConstant: titleW).isActive = true
        
        //TODO: - Description
        desLbl.font = UIFont(name: FontName.ppRegular, size: 17.0)
        desLbl.text = ""
        desLbl.textColor = .black
        desLbl.numberOfLines = 0
        desLbl.translatesAutoresizingMaskIntoConstraints = false
        desLbl.widthAnchor.constraint(equalToConstant: titleW).isActive = true
        
        //TODO: - UIStackView
        let stackView = UIStackView()
        stackView.spacing = 10.0
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.addArrangedSubview(avaSV)
        stackView.setCustomSpacing(20, after: avaSV)
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(desLbl)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
        ])
    }
    
    func updateUI(user: User, project: Project) {
        nameLbl.text = user.name == "" ? "New User" : user.name
        
        if let link = user.profileImageURL {
            DownloadImage.shared.downloadImage(link: link) { image in
                self.avatarImgView.image = image
            }
        }
        
        titleLbl.text = project.title
        desLbl.text = project.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        desLbl.isHidden = project.description == nil

        if let created = project.createdDate {
            let date = created.dateValue()
            let formatter = DateFormatter()

            formatter.dateFormat = "yyyy/MM/dd"
            createdTimeLbl.text = formatter.string(from: date)
        }
    }
}
