//
//  ProjectVC.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit
import Firebase

class ProjectVC: UIViewController {
    
    //MARK: - Properties
    private let projectView = ProjectView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var project: Project!
    var user: User!
    var selectedIndex = 0
    
    private var prHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavi()
        
        if let user = user, let project = project {
            projectView.updateUI(user: user, project: project)
            reloadData()
        }
        
        scrollTo()
    }
}

//MARK: - Setups

extension ProjectVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Content"
        
        //TODO: - ProjectView
        view.addSubview(projectView)
        projectView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        prHeightConstraint = projectView.heightAnchor.constraint(equalToConstant: 0.0)
        prHeightConstraint.priority = .defaultLow
        prHeightConstraint.isActive = true
        
        //TODO: - CollectionView
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProjectCVCell.self, forCellWithReuseIdentifier: ProjectCVCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 20.0
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            projectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: projectView.bottomAnchor, constant: 10.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavi() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationController?.view.backgroundColor = .white
    }
    
    private func scrollTo() {
        if project.posts.count != 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: self.selectedIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ProjectVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return project.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCVCell.id, for: indexPath) as! ProjectCVCell
        cell.post = project.posts[indexPath.item]
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProjectVC: UICollectionViewDelegate {}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProjectVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = project.posts[indexPath.item]
        let itemW = collectionView.bounds.size.width
        
        var featureW: CGFloat = 0.0
        if post.imageURL != nil {
            featureW = ((screenWidth - 40) * 9/16) + 5
        }
        
        var desH: CGFloat = 0.0
        if let des = post.description {
            desH = desHeight(des) + 15
        }
        
        let itemH: CGFloat = featureW + 19+15 + desH
        /*
         playerW = screenWidth - 40
         playerH = playerW * 9/16
         5
         createdTimeH: 19
         15
         desH: 21*
         15
         */
        
        return CGSize(width: itemW, height: itemH)
    }
    
    private func desHeight(_ txt: String) -> CGFloat {
        let font = UIFont(name: FontName.ppRegular, size: 17.0)!
        let desH = txt.estimatedText(font: font).width / (screenWidth-40)
        
        return desH * 21
    }
}
