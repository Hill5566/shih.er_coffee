//
//  LoginVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/3/14.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class LoginVC: CafeViewController {

    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("廢棄VC", self)
        
        accountTextField.layer.borderColor = UIColor.coffieColor.cgColor
        
        passwordTextField.layer.borderColor = UIColor.coffieColor.cgColor
        
        accountTextField.attributedPlaceholder = NSAttributedString(string: "手機號碼", attributes: [NSAttributedString.Key.foregroundColor: UIColor.coffieColor])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "密碼", attributes: [NSAttributedString.Key.foregroundColor: UIColor.coffieColor])
    }



    @IBAction func loginClick(_ sender: UIButton) {
        
        let mobile:String = accountTextField.text ?? ""
        
        let password:String = passwordTextField.text!
        
        if mobile.isPhoneNumber {
            
            self.showMessage("無此號碼", actions: nil)
            return
        }
        
        if password.count != 6 {
            
            self.showMessage("密碼錯誤", actions: nil)
            return
        }
        
        login(byMobile: mobile, password: password)
    }
    
    func login(byMobile mobile:String, password:String) {
        
        let query = PFQuery(className:Membership.className)
        
        query.whereKey(Membership.mobile, equalTo: mobile)
        
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error == nil {
                
                if let objects = objects {
                    
                    print(objects)
                    
                    if objects.count == 0 {
                        
                        self.showMessage("無此號碼", actions: nil)
                        
                    } else if objects.count == 1 {
                        
                        if let membership = objects.first {
                            
                            let mPassword:String = membership[Membership.password] as! String
                            
                            if password == mPassword {
                                
                                self.showMessage("TODO:登入", actions: nil)

                                
                            } else {
                                
                                self.showMessage("密碼錯誤", actions: nil)
                            }
                            
                        } else {
                            
                        }
                    
                    } else {
                        
                        self.showMessage("手機重複註冊, 資料異常", actions: nil)
                    }
                } else {
                    
                }
                
            } else {
                
                self.showMessage("網路或伺服器異常，請稍後再試", actions: nil)
            }
        }
    }

    func cooldown() {
        
        print("cool down 60s")
    }
    
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
    }
    
    
    
    
    
    
    

    
    

    
    

    
    

    
    

    
    

    
}
