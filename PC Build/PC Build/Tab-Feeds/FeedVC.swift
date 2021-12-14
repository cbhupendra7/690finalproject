//
//  FeedVC.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit
import Firebase

class FeedVC: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let refreshControl = UIRefreshControl()
    
    lazy var projects: [Project] = []
    lazy var userProjects: [UserProject] = []
    lazy var likes: [Like] = []
    lazy var arraySaved: [Saved] = []
    
    private var threeDotsVC: ThreeDotsVC?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi()
        
        if Auth.auth().currentUser != nil && userProjects.count == 0 {
            tableView.isHidden = false
            getProjects()
            
            NotificationCenter.default.addObserver(
                forName: notifName,
                object: nil,
                queue: nil) { _ in
                    self.userProjects.removeAll()
                    self.projects.removeAll()
                    appDL.userProjects.removeAll()
                    self.reloadData()

                    NotificationCenter.default.removeObserver(
                        self,
                        name: notifName,
                        object: nil)
                }
        }
    }
}

extension FeedVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Feed"
        
        //TODO: - TableView
        refreshControl.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.register(FeedTVCell.self, forCellReuseIdentifier: FeedTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        //If the user is not logged in
        if Auth.auth().currentUser == nil {
            let vc = WelcomeVC()
            let navi = NavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .fullScreen
            present(navi, animated: false, completion: nil)
            return
        }
    }
    
    private func setupNavi() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postDidTap))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        (navigationController as? NavigationController)?.setupNaviBar(.black, bgColor: .white, shadowColor: .lightGray.withAlphaComponent(0.5), isDark: false)
    }
    
    @objc private func postDidTap() {
        let vc = PostProjectVC()
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refreshHandler() {
        refreshControl.beginRefreshing()
        getProjects()
        
        delay(dr: 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - GetData

extension FeedVC {
    
    func getProjects() {
        var hud: HUD?
        if userProjects.count == 0 {
            hud = HUD.hud(view)
        }
        
        Project.fetchProjects { userProjects in
            hud?.removeHUD {}
            self.userProjects.removeAll()
            self.projects.removeAll()
            appDL.userProjects.removeAll()
            
            self.userProjects = userProjects
            appDL.userProjects = userProjects
            self.updateProjects()
        }
    }
    
    private func updateProjects() {
        for userPr in userProjects {
            for pr in userPr.projects {
                if !projects.contains(pr) {
                    projects.append(pr)
                }
            }
        }
        
        projects = projects.filter({
            $0.description != nil || $0.posts.count != 0
        })
        
        projects = projects.sorted(by: {
            $0.createdDate!.dateValue() > $1.createdDate!.dateValue()
        })
        
        getLikes()
    }
    
    private func getLikes() {
        Like.fetchLikes { likes in
            self.likes.removeAll()
            self.likes = likes
            
            if self.likes.count != 0 {
                for like in self.likes {
                    if let index = self.projects.firstIndex(where: {
                        $0.uid == like.projectID
                    }) {
                        self.projects[index].model.like = like
                    }
                }
            }
            
            self.getSaved()
        }
    }
    
    private func getSaved() {
        Saved.fetchArraySaved { array in
            self.arraySaved.removeAll()
            self.arraySaved = array
            
            if self.arraySaved.count != 0 {
                for saved in self.arraySaved {
                    if let index = self.projects.firstIndex(where: {
                        $0.user?.uid == saved.userID
                    }) {
                        self.projects[index].model.saved = saved
                    }
                }
            }
            
            self.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension FeedVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTVCell.id, for: indexPath) as! FeedTVCell
        let model = projects[indexPath.row]
        
        cell.selectionStyle = .none
        cell.model = model
        cell.delegate = self
        
        if let user = model.user {
            cell.user = user
            cell.likeCountLbl.isHidden = model.like == nil
            
            if let like = model.like {
                cell.isLike = like.userIDs.contains(user.uid)
                cell.likeCountLbl.text = kText(Double(like.userIDs.count))
                cell.likeCountLbl.isHidden = like.userIDs.count == 0
            }
        }
        
        if let saved = model.saved {
            cell.isSaved = saved.projectIDs.contains(model.uid)
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension FeedVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ProjectVC()
        let model = projects[indexPath.row]
        
        vc.project = model
        vc.user = model.user

        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    private func itemHeight(_ indexPath: IndexPath) -> CGFloat {
        let model = projects[indexPath.item]
        let isDes = model.description == nil || model.description == ""
        let desH = isDes ? 10.0 : (10 + desHeight(model.description ?? ""))
        
        let imgH: CGFloat = ((screenWidth-60)/3)*2 + 5
        let height: CGFloat = 5 + 55 + imgH + desH + 15 + 40
        
        return height
    }
    
    private func desHeight(_ txt: String) -> CGFloat {
        let font = UIFont(name: FontName.ppRegular, size: 17.0)!
        let txtH = txt.estimatedText(font: font).width / (screenWidth-50)
        let desH = getDescriptionHeight(txtH)
        
        return desH
    }
    
    private func getDescriptionHeight(_ txtH: CGFloat) -> CGFloat {
        let i: CGFloat = 21.0
        var desH: CGFloat = 1
        
        if txtH >= 4 || txtH >= 3 {
            desH = 4
            
        } else if txtH >= 2 {
            desH = 3
            
        } else if txtH >= 1 {
            desH = 2
        }
        
        return desH * i
    }
}

//MARK: - FeedTVCellDelegate

extension FeedVC: FeedTVCellDelegate {

    func dotsDidTap(_ cell: FeedTVCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let model = projects[indexPath.row]
            let isCurrent = Auth.auth().currentUser?.uid == model.user?.uid
            
            threeDotsVC?.removeFromParent()
            threeDotsVC = nil
            
            threeDotsVC = ThreeDotsVC()
            
            threeDotsVC = ThreeDotsVC()
            threeDotsVC!.view.frame = kWindow.bounds
            threeDotsVC!.delegate = self
            threeDotsVC!.currentUser = model.user
            threeDotsVC!.project = model
            kWindow.addSubview(threeDotsVC!.view)
            
            let dotsF = cell.dotsBtn.convert(cell.dotsBtn.frame, to: kWindow)
            let dotsH: CGFloat = 50 * (isCurrent ? 2 : 1)
            
            threeDotsVC!.setupContainerView(dotsF, dotsH: dotsH)
        }
    }
    
    func likeDidTap(_ cell: FeedTVCell) {
        cell.isLike = !cell.isLike
        
        if let indexPath = tableView.indexPath(for: cell) {
            let pr = projects[indexPath.row]
            let likeModel = LikeModel(projectID: pr.uid)
            let like = Like(model: likeModel)
            
            if cell.isLike {
                like.saveLike { error in
                    if let error = error {
                        print("saveLike error: \(error.localizedDescription)")
                    }
                    
                    self.getLikes()
                }
                
            } else {
                projects[indexPath.row].model.like = nil
                
                like.deleteLike { error in
                    if let error = error {
                        print("deleteLike error: \(error.localizedDescription)")
                    }
                    
                    self.getLikes()
                }
            }
        }
    }
    
    func savedDidTap(_ cell: FeedTVCell) {
        cell.isSaved = !cell.isSaved
        
        if let indexPath = tableView.indexPath(for: cell) {
            let pr = projects[indexPath.row]
            let model = SavedModel()
            let saved = Saved(model: model)
            
            if cell.isSaved {
                saved.saveSaved(prID: pr.uid) { error in
                    if let error = error {
                        print("saveSaved error: \(error.localizedDescription)")
                    }
                    
                    self.getSaved()
                }
                
            } else {
                projects[indexPath.row].model.saved = nil
                
                saved.deleteSaved(prID: pr.uid) { error in
                    if let error = error {
                        print("deleteSaved error: \(error.localizedDescription)")
                    }
                    
                    self.getSaved()
                }
            }
        }
    }
}

//MARK: - ThreeDotsVCDelegate

extension FeedVC: ThreeDotsVCDelegate {
    
    func editDidSelect(_ vc: ThreeDotsVC, project: Project) {
        vc.removeHandler {
            let vc = PostProjectVC()
            vc.isEdit = true
            vc.project = project
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func deleteDidSelect(_ vc: ThreeDotsVC, project: Project) {
        vc.removeHandler {
            self.handleDelete(project)
        }
    }
    
    func handleDelete(_ project: Project) {
        let alert = UIAlertController(title: "Are you sure want to delete this project?", message: nil, preferredStyle: .alert)
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAct = UIAlertAction(title: "Delete", style: .default) { _ in
            if let index = self.projects.firstIndex(of: project) {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.beginUpdates()
                self.projects.remove(at: index)
                self.tableView.deleteRows(at: [indexPath], with: .none)
                self.tableView.endUpdates()
                
                let hud = HUD.hud(kWindow)
                project.deleteProject {
                    hud.removeHUD {}
                }
            }
        }
        
        alert.addAction(cancelAct)
        alert.addAction(okAct)
        present(alert, animated: true, completion: nil)
    }
}
