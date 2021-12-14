//
//  AppDelegate.swift
//  PC Build
//
//  Created by Thanh Hoang on 18/11/2021.
//

import UIKit
import Firebase
import FirebaseStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var userProjects: [UserProject] = []

    //TODO: - Device
    var isAllIPad = false
    var isIPadPro = false
    var isIPad11 = false
    var isIPad12 = false
    var isIPad = false
    
    var isIPhoneX = false
    var isIPhonePlus = false
    var isIPhone = false
    var isIPhone5 = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //TODO: - Firebase
        FirebaseApp.configure()
        
        //TODO: - UIDevice
        setupDevices()
        
        //TODO: - Appearance
        setupAppearance()
        
        //TODO: - SignOut
        setupLogOut()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//MARK: - Setups

extension AppDelegate {
    
    private func setupDevices() {
        //TODO: - UIDevice
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            isAllIPad = true
            
            switch UIScreen.main.nativeBounds.height {
            case 2388: isIPad11 = true; break
            case 2732: isIPad12 = true; break
            default: isIPadPro = true; break
            }
            
            if isIPad12 || isIPadPro {
                isIPad = true
            }
            
        case .phone:
            switch UIScreen.main.nativeBounds.height {
            case 2688, 1792, 2436: isIPhoneX = true; break
            case 2208, 1920: isIPhonePlus = true; break
            case 1334: isIPhone = true; break
            case 1136: isIPhone5 = true; break
            default: isIPhoneX = true; break
            }
        case .tv: break
        default: break
        }
    }
    
    private func setupAppearance() {
        //TODO: - UITabBar
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .white
    }
    
    private func setupLogOut() {
        if !UserDefaults.standard.bool(forKey: User.signOutKey) {
            do {
                try Auth.auth().signOut()
                
            } catch {}
            
            UserDefaults.standard.setValue(true, forKey: User.signOutKey)
            UserDefaults.standard.synchronize()
        }
    }
}
