//
//  LogInVC.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit
import Firebase

class LogInVC: UIViewController {
    
    //MARK: - Properties
    private let emailTF = UITextField()
    private let passwordTF = UITextField()
    private let eyeImgView = UIImageView()
    
    private let forgetPassBtn = ButtonAnimation()
    private let logInBtn = ButtonAnimation()
    
    private let forgetPassTxt = "Forgot Password?"
    
    private var password = ""
    private var email = ""
    private var eyeShow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}

//MARK: - Setups

extension LogInVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "LOGIN TO YOUR ACCOUNT"
        
        //TODO: - Email
        let emailPlTxt = "Email"
        emailTF.configureFromTF(emailPlTxt, imgName: "icon-email")
        emailTF.keyboardType = .emailAddress
        emailTF.autocapitalizationType = .none
        emailTF.delegate = self
        
        //TODO: - Password
        passwordTF.configureFromTFLeftRightView("Password", imgName: "icon-password", rightImgView: eyeImgView)
        passwordTF.isSecureTextEntry = true
        passwordTF.delegate = self
        
        //TODO: - Password
        let eyeTap = UITapGestureRecognizer(target: self, action: #selector(eyeDidTap))
        eyeImgView.addGestureRecognizer(eyeTap)
        
        let emailSV = UIStackView(arrangedSubviews: [emailTF, passwordTF])
        emailSV.spacing = 20.0
        emailSV.axis = .vertical
        emailSV.distribution = .fill
        emailSV.alignment = .center
        view.addSubview(emailSV)
        emailSV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ForgetPassword
        let fAtt = [
            NSAttributedString.Key.font : UIFont(name: FontName.ppBold, size: 13.0)!,
            NSAttributedString.Key.foregroundColor : UIColor(hex: 0x3F7BEF)
        ]
        let fAttr = NSMutableAttributedString(string: forgetPassTxt, attributes: fAtt)
        forgetPassBtn.setAttributedTitle(fAttr, for: .normal)
        forgetPassBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        forgetPassBtn.delegate = self
        forgetPassBtn.tag = 1
        view.addSubview(forgetPassBtn)
        forgetPassBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - LogIn
        let loginW: CGFloat = screenWidth * 0.9
        let loginH: CGFloat = 50.0
        let loginAtt = [
            NSAttributedString.Key.font : UIFont(name: FontName.ppBold, size: 18.0)!,
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        let loginAttr = NSMutableAttributedString(string: "Log In", attributes: loginAtt)
        logInBtn.setAttributedTitle(loginAttr, for: .normal)
        logInBtn.backgroundColor = UIColor(hex: 0x3F7BEF)
        logInBtn.clipsToBounds = true
        logInBtn.layer.cornerRadius = loginH/2
        logInBtn.layer.borderColor = UIColor.clear.cgColor
        logInBtn.layer.borderWidth = 1.0
        logInBtn.delegate = self
        logInBtn.tag = 2
        logInBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        view.addSubview(logInBtn)
        logInBtn.translatesAutoresizingMaskIntoConstraints = false
        logInBtn.widthAnchor.constraint(equalToConstant: loginW).isActive = true
        logInBtn.heightAnchor.constraint(equalToConstant: loginH).isActive = true
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            emailSV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            emailSV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            forgetPassBtn.trailingAnchor.constraint(equalTo: emailSV.trailingAnchor),
            forgetPassBtn.topAnchor.constraint(equalTo: emailSV.bottomAnchor, constant: 5.0),
            
            logInBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInBtn.topAnchor.constraint(equalTo: forgetPassBtn.bottomAnchor, constant: 20.0),
        ])
        
        let endTap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        endTap.cancelsTouchesInView = false
        view.addGestureRecognizer(endTap)
    }
    
    @objc private func eyeDidTap() {
        eyeShow = !eyeShow
        eyeImgView.image = UIImage(named: eyeShow ? "icon-eyeOff" : "icon-eyeOn")
        passwordTF.isSecureTextEntry = !eyeShow
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
    
    private func handleError(_ txt: String, view: UIView) {
        if !txt.isEmpty {
            borderView(view, color: .lightGray)
            
        } else {
            setupAnimBorderView(view)
        }
    }
}

//MARK: - UITextFieldDelegate

extension LogInVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            if let text = emailTF.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.isValidEmail {
                
                borderView(emailTF, color: .lightGray)
                email = text
                passwordTF.becomeFirstResponder()
                
                if text == "hoangnguyenmtv75@gmail.com" {
                    passwordTF.text = "22222222"
                    password = "22222222"
                }
                
            } else {
                setupAnimBorderView(emailTF)
                email = ""
                emailTF.becomeFirstResponder()
            }
            
        } else if textField == passwordTF {
            if let text = passwordTF.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.count >= 8 {
                borderView(passwordTF, color: .lightGray)
                password = text
                loginDidTap()
                
            } else {
                setupAnimBorderView(passwordTF)
                password = ""
                passwordTF.becomeFirstResponder()
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF {
            if let text = emailTF.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.isValidEmail {
                borderView(emailTF, color: .lightGray)
                email = text
                
            } else {
                setupAnimBorderView(emailTF)
                email = ""
            }
            
        } else if textField.text == passwordTF.text {
            if let text = passwordTF.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.count >= 8 {
                borderView(passwordTF, color: .lightGray)
                password = text
                
            } else {
                setupAnimBorderView(passwordTF)
                password = ""
            }
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension LogInVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 1 { //Forgot Password
            forgotPassword()
            
        } else if sender.tag == 2 { //Login
            loginDidTap()
        }
    }
    
    private func forgotPassword() {
        let title = "Reset Your Password"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            let txt = "Enter email address"
            textField.placeholder = txt
            textField.font = UIFont(name: FontName.ppRegular, size: 17.0)
            textField.keyboardType = .emailAddress
        }
        
        let cancelTxt = NSLocalizedString("Cancel", comment: "LogInVC.swift: Cancel")
        let cancelAct = UIAlertAction(title: cancelTxt, style: .cancel, handler: nil)
        
        let resetTxt = NSLocalizedString("Reset", comment: "LogInVC.swift: Reset")
        let resetAct = UIAlertAction(title: resetTxt, style: .default) { (_) in
            guard let tf = alert.textFields?.first else { return }
            if let text = tf.text,
                !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                text.isValidEmail {
                let hud = HUD.hud(kWindow)
                
                Auth.auth().sendPasswordReset(withEmail: text) { (error) in
                    guard error == nil else {
                        hud.removeFromSuperview()
                        
                        let mesTxt = "Email address does not exist"
                        handleErrorAlert("Whoops!!!", mes: mesTxt, act: "OK", vc: self)
                        return
                    }
                    
                    hud.removeHUD {
                        let titleTxt = "Success"
                        let mesTxt = "Check your email address"
                        handleErrorAlert(titleTxt, mes: mesTxt, act: "OK", vc: self)
                    }
                }
            }
        }
        
        alert.addAction(cancelAct)
        alert.addAction(resetAct)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func loginDidTap() {
        endEditing()
        
//        view.window?.rootViewController?.dismiss(animated: true)
        
        handleError(email, view: emailTF)
        handleError(password, view: passwordTF)
        
        guard email != "" else {
            return
        }
        
        guard password != "" else {
            return
        }
        
        print("===============//===============")
        print("Email: \(email)")
        print("Password: \(password)")
        
        let hud = HUD.hud(kWindow)
        
        User.signIn(email: email, password: password) { result, error in
            if let error = error {
                hud.removeHUD {}
                handleErrorAlert(error.localizedDescription, mes: nil, act: "OK", vc: self)

            } else {
                User.reloadCurrentUser {
                    hud.removeHUD {}
                    UserDefaults.standard.setValue(true, forKey: User.signOutKey)

                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
