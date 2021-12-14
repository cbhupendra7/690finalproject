//
//  NavigationController.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

class NavigationController: UINavigationController {

    //MARK: - Properties
    private var duringPushAnim = false
    var darkBarStyle = false
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkBarStyle ? .lightContent : .darkContent
    }
}

//MARK: - Setups

extension NavigationController {
    
    private func setupViews() {
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.barTintColor = .white
        
        setupNaviBar(.black, bgColor: .white, shadowColor: .lightGray.withAlphaComponent(0.5), isDark: false)
    }
    
    func setupNaviBar(_ tintC: UIColor, bgColor: UIColor, shadowColor: UIColor, isDark: Bool) {
        navigationBar.tintColor = tintC
        
        let titleAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppSemiBold, size: 22.0)!,
            .foregroundColor: tintC
        ]
        let btnAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppSemiBold, size: 17.0)!,
            .foregroundColor: tintC
        ]
        let disBtnAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppSemiBold, size: 17.0)!,
            .foregroundColor: UIColor.lightGray
        ]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = titleAttr
        appearance.backgroundColor = bgColor
        appearance.shadowColor = shadowColor

        let barBtn = UIBarButtonItemAppearance(style: .plain)
        barBtn.normal.titleTextAttributes = btnAttr
        barBtn.disabled.titleTextAttributes = disBtnAttr
        appearance.buttonAppearance = barBtn

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        darkBarStyle = isDark
        setNeedsStatusBarAppearanceUpdate()
    }
}

//MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipe = navigationController as? NavigationController else {
            return
        }
        swipe.duringPushAnim = true
    }
}

//MARK: - UIGestureRecognizerDelegate

extension NavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
        return viewControllers.count > 1 && !duringPushAnim
    }
}
