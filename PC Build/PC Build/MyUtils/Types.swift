//
//  Types.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

let appDL = UIApplication.shared.delegate as! AppDelegate
let sceneDL = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate

let kWindow = sceneDL.window!.windowScene!.windows.first!
let notifName = Notification.Name(User.signOutKey)

public func delay(dr: TimeInterval, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + dr, execute: completion)
}

public func borderView(_ view: UIView, color: UIColor = .white) {
    view.layer.borderColor = color.cgColor
}

public func setupAnimBorderView(_ view: UIView) {
    let posAnim = CABasicAnimation(keyPath: "position.x")
    posAnim.fromValue = view.center.x + 2.0
    posAnim.toValue = view.center.x - 2.0
    
    let borderAnim = CASpringAnimation(keyPath: "borderColor")
    borderAnim.damping = 5.0
    borderAnim.initialVelocity = 10.0
    borderAnim.toValue = UIColor(hex: 0xFF755F).cgColor
    
    let animGroup = CAAnimationGroup()
    animGroup.duration = 0.1
    animGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
    animGroup.autoreverses = true
    animGroup.animations = [posAnim, borderAnim]
    
    view.layer.add(animGroup, forKey: nil)
    view.layer.borderColor = UIColor(hex: 0xFF755F).cgColor
}

public func handleErrorAlert(_ title: String?, mes: String?, act: String, vc: UIViewController, completion: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: mes, preferredStyle: .alert)
    let act = UIAlertAction(title: act, style: .cancel) { (_) in completion?() }
    
    alert.addAction(act)
    vc.present(alert, animated: true, completion: nil)
}

//MARK: - Text

func kText(_ num: Double) -> String {
    var txt: String {
        if num >= 1000 && num < 999999 {
            return String(format: "%0.1fK", locale: .current, num/1_000)
                .replacingOccurrences(of: ".0", with: "")
        }
        
        if num > 999999 {
            return String(format: "%0.1fM", locale: .current, num/1_000_000)
                .replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%0.0f", locale: .current, num)
    }
    
    return txt
}
