//
//  UIManager.swift
//  CafeCoin
//
//  Created by Hill Lin on 2020/9/17.
//  Copyright © 2020 Lin Hill. All rights reserved.
//

import UIKit

class UIManager: NSObject {
    
    static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    static var mainStoryboard:UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
 
    static func switchToHomeVC() {
        keyWindow?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "NaviHome")
    }
    
    static func switchToBossLogin() {
        keyWindow?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "BossLoginVC")
    }
    
//    static func switchToLogin() {
//        keyWindow?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC")
//    }
//
//    static func switchToRegister() {
//        keyWindow?.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "RegisterVC")
//    }
//
//    static func switchToResetpassword() {
////        keyWindow?.rootViewController = loginStoryboard.instantiateViewController(withIdentifier: "ResetVC")
//    }
    
   
}
