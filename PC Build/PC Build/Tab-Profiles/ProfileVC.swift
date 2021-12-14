//
//  ProfileVC.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    //MARK: - Properties
    let scrollView = PrScrollView()
    let refreshControl = UIRefreshControl()
    
    var containerView: PrContainerView { return scrollView.containerView }
    var avatarView: PrAvatarView { return containerView.avatarView }
    
    var projectsView: PrProjectsView { return containerView.projectsView }
    var tableView: UITableView { return projectsView.tableView }
    
    var user: User!
    lazy var projects: [Project] = []
    lazy var likeProjects: [Project] = []
    lazy var savedProjects: [Project] = []
    
    private var selectedIndex = 0
    var isLoad = false
    var hud: HUD?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi()
        
        if user == nil {
            getCurrentUser()
        }
        
        if projects.count == 0 {
            getProjects()
        }
        
        if likeProjects.count == 0 {
            getLikes()
        }
        
        if savedProjects.count == 0 {
            getSaved()
        }
        
        NotificationCenter.default.addObserver(
            forName: notifName,
            object: nil,
            queue: nil) { _ in
                self.user = nil
                self.projects.removeAll()
                self.likeProjects.removeAll()
                self.savedProjects.removeAll()
                self.isLoad = false
                self.selectedIndex = 0
                self.projectsView.segmentedControl.selectedSegmentIndex = self.selectedIndex

                NotificationCenter.default.removeObserver(
                    self,
                    name: notifName,
                    object: nil)
            }
    }
}

//MARK: - Setups

extension ProfileVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Profile"
        
        //TODO: - ScrollView
        scrollView.setupViews(self, dl: self)
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 100, bottom: 0.0, right: 20.0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1))
        
        projectsView.segmentedControl.addTarget(self, action: #selector(segmentedAct), for: .valueChanged)
    }
    
    private func setupNavi() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editDidTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutDidTap))
        
        (navigationController as? NavigationController)?.setupNaviBar(.white, bgColor: UIColor(hex: 0x3F7BEF), shadowColor: .clear, isDark: true)
    }
    
    @objc private func editDidTap() {
        let vc = EditProfileVC()
        vc.user = user
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logoutDidTap() {
        NotificationCenter.default.post(name: notifName, object: nil)
        DownloadImage.shared.removeCache()
        
        User.signOut {
            UserDefaults.standard.setValue(false, forKey: User.signOutKey)

            let vc = LogInVC()
            let navi = UINavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    @objc private func refreshHandler() {
        refreshControl.beginRefreshing()
        getCurrentUser()
        getProjects()
        
        delay(dr: 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func segmentedAct(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        reloadData()
    }
}

//MARK: - GetData

extension ProfileVC {
    
    private func getCurrentUser() {
        if !isLoad {
            isLoad = true
            hud = HUD.hud(view)
        }
        
        User.fetchCurrentUser { user in
            self.user = user
            self.hud?.removeHUD {}
            
            guard let user = self.user else {
                return
            }
            
            self.containerView.updateUI(user)
        }
    }
    
    private func getProjects() {
        if let uid = Auth.auth().currentUser?.uid {
            Project.fetchProjects(userUID: uid) { projects in
                self.projects.removeAll()
                self.projects = projects
                self.reloadData()
            }
        }
    }
    
    private func getLikes() {
        Like.fetchLikes { likes in
            self.likeProjects.removeAll()
            
            if likes.count != 0 {
                var prs: [Project] = []
                if let userPr = appDL.userProjects.first(where: { $0.user.uid == self.user.uid }) {
                    prs = userPr.projects
                }
                
                for like in likes {
                    if like.userIDs.contains(where: { $0 == self.user.uid }),
                       let project = prs.first(where: { $0.uid == like.projectID }),
                       !self.likeProjects.contains(project) {
                        self.likeProjects.append(project)
                    }
                }
            }
            
            self.reloadData()
        }
    }
    
    private func getSaved() {
        Saved.fetchSaved(isListener: true) { saved in
            self.savedProjects.removeAll()
            
            if let saved = saved {
                var prs: [Project] = []
                if let userPr = appDL.userProjects.first(where: { $0.user.uid == self.user.uid }) {
                    prs = userPr.projects
                }
                
                for prID in saved.projectIDs {
                    if let project = prs.first(where: { $0.uid == prID }),
                       !self.savedProjects.contains(project) {
                        self.savedProjects.append(project)
                    }
                }
            }
            
            print("self.savedProjects.count: \(self.savedProjects.count)")
            self.reloadData()
        }
    }
}

//MARK: - UIScrollViewDelegate

extension ProfileVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let defaultTop: CGFloat = 0.0
        var currentTop: CGFloat = defaultTop

        if offsetY < 0.0 {
            currentTop = offsetY
            avatarView.coverHeightLayout.constant = containerView.coverH - offsetY
            containerView.avatarHeightLayout.constant = containerView.avatarH - offsetY

        } else {
            avatarView.coverHeightLayout.constant = containerView.coverH
            containerView.avatarHeightLayout.constant = containerView.avatarH
        }

        self.scrollView.cvTopLayout.constant = currentTop
    }
}

//MARK: - UITableViewDataSource

extension ProfileVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return projects.count
            
        } else if selectedIndex == 1 {
            return likeProjects.count
            
        } else {
            return savedProjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrProjectTVCell.id, for: indexPath) as! PrProjectTVCell
        if selectedIndex == 0 {
            cell.model = projects[indexPath.row]
            
        } else if selectedIndex == 1 {
            cell.model = likeProjects[indexPath.row]
            
        } else {
            cell.model = savedProjects[indexPath.row]
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ProfileVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ProjectVC()
        
        let project: Project
        if selectedIndex == 0 {
            project = projects[indexPath.row]
            
        } else if selectedIndex == 1 {
            project = likeProjects[indexPath.row]
            
        } else {
            project = savedProjects[indexPath.row]
        }
        
        project.model.user = user
        vc.project = project
        vc.user = user

        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}
