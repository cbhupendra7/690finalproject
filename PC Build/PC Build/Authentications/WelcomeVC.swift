//
//  WelcomeVC.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

class WelcomeVC: UIViewController {
    
    //MARK: - Properties
    let imageView = UIImageView()
    let titleLbl = UILabel()
    let logInBtn = ButtonAnimation()
    let signUpBtn = ButtonAnimation()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}

//MARK: - Setups

extension WelcomeVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        //TODO: - ImageView
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "welcome")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: screenWidth*0.5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: (screenWidth*0.5)*1.13).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppBold, size: 25)
        titleLbl.text = "Welcome to PC Build"
        titleLbl.textAlignment = .center
        
        //TODO: - UIStackView
        let welcomeSV = UIStackView(arrangedSubviews: [imageView, titleLbl])
        welcomeSV.spacing = 40.0
        welcomeSV.axis = .vertical
        welcomeSV.alignment = .center
        welcomeSV.distribution = .fill
        view.addSubview(welcomeSV)
        welcomeSV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - LogInBtn
        let loginAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 18.0)!,
            .foregroundColor: UIColor.white
        ]
        let loginAttr = NSMutableAttributedString(string: "Log In", attributes: loginAtt)
        let signUpAttr = NSMutableAttributedString(string: "Sign Up", attributes: loginAtt)
        
        setupBtn(logInBtn, tag: 1)
        logInBtn.setAttributedTitle(loginAttr, for: .normal)
        
        //TODO: - SignUpBtn
        setupBtn(signUpBtn, tag: 2)
        signUpBtn.setAttributedTitle(signUpAttr, for: .normal)
        
        //TODO: - UIStackView
        let btnSV = UIStackView(arrangedSubviews: [logInBtn, signUpBtn])
        btnSV.spacing = 10.0
        btnSV.axis = .vertical
        btnSV.alignment = .center
        btnSV.distribution = .fill
        view.addSubview(btnSV)
        btnSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeSV.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30.0),
            
            btnSV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30.0),
            btnSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupBtn(_ btn: ButtonAnimation, tag: Int) {
        let btnH: CGFloat = 50.0
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor(hex: 0x3F7BEF)
        btn.layer.cornerRadius = btnH/2
        btn.tag = tag
        btn.delegate = self
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: screenWidth*0.9).isActive = true
        btn.heightAnchor.constraint(equalToConstant: btnH).isActive = true
    }
}

//MARK: - ButtonAnimationDelegate

extension WelcomeVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Log In
            let vc = LogInVC()
            navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 2 { //Sign Up
            let vc = SignUpVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
