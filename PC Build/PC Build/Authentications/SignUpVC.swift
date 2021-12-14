//
//  SignUpVC.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView()
    
    private var usernameTF: UITextField!
    private var emailTF: UITextField!
    private var passwordTF: UITextField!
    private var checkTVCell: CheckTVCell?
    
    private var username = ""
    private var email = ""
    private var password = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Setups

extension SignUpVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "CREATE NEW ACCOUNT"
        
        let endTap = UITapGestureRecognizer(target: self, action: #selector(handleEndEditing))
        endTap.cancelsTouchesInView = false
        view.addGestureRecognizer(endTap)
        
        //TODO: - TableView
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.register(UsernameTVCell.self, forCellReuseIdentifier: UsernameTVCell.id)
        tableView.register(EmailTVCell.self, forCellReuseIdentifier: EmailTVCell.id)
        tableView.register(PasswordTVCell.self, forCellReuseIdentifier: PasswordTVCell.id)
        tableView.register(CheckTVCell.self, forCellReuseIdentifier: CheckTVCell.id)
        tableView.register(CreateNewAccTVCell.self, forCellReuseIdentifier: CreateNewAccTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func handleEndEditing() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: duration) {
                self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        if let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: duration) {
                self.tableView.contentInset = .zero
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension SignUpVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UsernameTVCell.id, for: indexPath) as! UsernameTVCell
            cell.selectionStyle = .none
            usernameTF = cell.textField
            usernameTF?.delegate = self
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmailTVCell.id, for: indexPath) as! EmailTVCell
            cell.selectionStyle = .none
            emailTF = cell.textField
            emailTF?.delegate = self
            
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PasswordTVCell.id, for: indexPath) as! PasswordTVCell
            cell.selectionStyle = .none
            cell.delegate = self
            passwordTF = cell.textField
            passwordTF?.delegate = self
            
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckTVCell.id, for: indexPath) as! CheckTVCell
            cell.selectionStyle = .none
            checkTVCell = cell
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(checkDidTap))
            cell.checkView.isUserInteractionEnabled = true
            cell.checkView.addGestureRecognizer(tap)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateNewAccTVCell.id, for: indexPath) as! CreateNewAccTVCell
            cell.selectionStyle = .none
            cell.signUpBtn.delegate = self
            
            return cell
        }
    }
    
    @objc func checkDidTap() {
        guard let checkTVCell = checkTVCell else { return }
        checkTVCell.isCheck = !checkTVCell.isCheck
        reloadData()
    }
}

//MARK: - UITableViewDelegate

extension SignUpVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.item == 3 ? 100 : 70
    }
}

//MARK: - UITextFieldDelegate

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTF {
            if let text = usernameTF.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.count >= 6 {
                borderView(usernameTF, color: .lightGray)
                username = text
                emailTF.becomeFirstResponder()
                
            } else {
                setupAnimBorderView(usernameTF)
                username = ""
                usernameTF.becomeFirstResponder()
            }
            
        } else if textField == emailTF {
            if let text = emailTF.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.isValidEmail {
                borderView(emailTF, color: .lightGray)
                email = text
                passwordTF.becomeFirstResponder()
                
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
        if textField == usernameTF {
            if let text = usernameTF.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.count >= 8 {
                borderView(usernameTF, color: .lightGray)
                username = text
                
            } else {
                setupAnimBorderView(usernameTF)
                username = ""
            }
            
        } else if textField == emailTF {
            if let text = emailTF.text,
               !text.trimmingCharacters(in: .whitespaces).isEmpty,
               text.isValidEmail {
                borderView(emailTF, color: .lightGray)
                email = text
                
            } else {
                setupAnimBorderView(emailTF)
                email = ""
            }
            
        } else if textField == passwordTF {
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

//MARK: - PasswordTVCellDelegate

extension SignUpVC: PasswordTVCellDelegate {
    
    func passEyeDidTap(_ cell: PasswordTVCell) {
        cell.isShow = !cell.isShow
        reloadData()
    }
}

//MARK: - ButtonAnimationDelegate

extension SignUpVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        loginDidTap()
    }
    
    private func loginDidTap() {
        tableView.endEditing(true)
        
        handleError(email, view: emailTF)
        handleError(username, view: usernameTF)
        handleError(password, view: passwordTF)
        
        guard email != "" else {
            return
        }
        
        guard username != "" else {
            return
        }
        
        guard password != "" else {
            return
        }
        
        //Checkmark
        
        print("===============//===============")
        print("Email: \(email)")
        print("Username: \(username)")
        print("Password: \(password)")
        
        handleSignUp()
    }
    
    func handleSignUp() {
        let hud = HUD.hud(kWindow)
        
        User.checkUserAlreadyExists(email: email) { exists in
            if exists {
                hud.removeHUD {}

                let title = "Email already exists."
                handleErrorAlert(title, mes: nil, act: "OK", vc: self)

            } else {
                User.createAccount(email: self.email, password: self.password) { result, error in
                    if let error = error {
                        hud.removeHUD {}
                        print("createAccount error: \(error.localizedDescription)")

                    } else {
                        if let authUser = result?.user {
                            let receiveNewsletter = self.checkTVCell?.isCheck ?? false
                            let model = UserModel(uid: authUser.uid, name: self.username, email: self.email, receiveNewsletter: receiveNewsletter)
                            let user = User(model: model)

                            user.saveUser { error in
                                if let error = error {
                                    hud.removeHUD {}
                                    print("saveUser error: \(error.localizedDescription)")

                                } else {
                                    User.reloadCurrentUser {
                                        hud.removeHUD {}
                                        UserDefaults.standard.setValue(true, forKey: User.signOutKey)

                                        self.view.window?.rootViewController?.dismiss(animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func handleError(_ txt: String, view: UIView) {
        if !txt.isEmpty {
            borderView(view, color: .lightGray)
            
        } else {
            setupAnimBorderView(view)
        }
    }
}
