//
//  ThreeDotsVC.swift
//  PC Build
//
//  Created by Thanh Hoang on 20/11/2021.
//

import UIKit
import Firebase

protocol ThreeDotsVCDelegate: AnyObject {
    func editDidSelect(_ vc: ThreeDotsVC, project: Project)
    func deleteDidSelect(_ vc: ThreeDotsVC, project: Project)
}

class ThreeDotsVC: UIViewController {

    //MARK: - Properties
    weak var delegate: ThreeDotsVCDelegate?
    
    let containerView = UIView()
    let threeDotsView = UIView()
    let tableView = UITableView(frame: .zero)
    
    lazy var models: [ThreeDotsModel] = {
        return ThreeDotsModel.shared()
    }()
    
    var project: Project?
    var currentUser: User?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser?.uid != currentUser?.uid {
            models.removeLast()
            tableView.reloadData()
        }
    }
}

//MARK: - Setups

extension ThreeDotsVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        containerView.isUserInteractionEnabled = true
        view.addSubview(containerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        containerView.addGestureRecognizer(tap)
    }
    
    @objc private func removeDidTap(_ sender: UIGestureRecognizer) {
        removeHandler {}
    }
    
    func setupContainerView(_ dotsF: CGRect, dotsH: CGFloat) {
        //TODO: - ThreeDotsView
        let dotsW: CGFloat = screenWidth/2
        let dotsX: CGFloat = screenWidth - dotsW - 40
        let dotsY: CGFloat = dotsF.origin.y
        let dotsRect = CGRect(x: dotsX, y: dotsY, width: dotsW, height: dotsH)

        threeDotsView.clipsToBounds = true
        threeDotsView.backgroundColor = .white
        threeDotsView.layer.cornerRadius = 10.0
        threeDotsView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        threeDotsView.frame = dotsRect
        view.insertSubview(threeDotsView, aboveSubview: containerView)
        
        threeDotsView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        
        UIView.animate(withDuration: 0.33) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.threeDotsView.transform = .identity
        }
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 50.0
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.register(ThreeDotsTVCell.self, forCellReuseIdentifier: ThreeDotsTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        threeDotsView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: threeDotsView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: threeDotsView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: threeDotsView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: threeDotsView.bottomAnchor),
        ])
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.threeDotsView.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            self.threeDotsView.alpha = 0.0
            
        } completion: { (_) in
            self.view.removeFromSuperview()
            completion()
        }
    }
}

//MARK: - UITableViewDataSource

extension ThreeDotsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThreeDotsTVCell.id, for: indexPath) as! ThreeDotsTVCell
        cell.model = models[indexPath.row]
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ThreeDotsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let project = project else { return }
        
        if indexPath.row == 0 {
            delegate?.editDidSelect(self, project: project)
            
        } else {
            delegate?.deleteDidSelect(self, project: project)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}
