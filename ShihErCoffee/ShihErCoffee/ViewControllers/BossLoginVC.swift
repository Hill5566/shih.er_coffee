//
//  BossLoginVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/5/30.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class BossLoginVC: CafeViewController {

    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        #if CAFE_DEBUG
        accountTextField.text = "HillDebug"
        passwordTextField.text = "7788"
        #endif

        setCafeTextField(accountTextField, placeHolderString: "使用者名稱")
        
        setCafeTextField(passwordTextField, placeHolderString: "密碼")
    }

    func signUp() {
        
        let newUser = PFUser()

        newUser.username = "Hill"
        
        newUser.password = "1234"
        
        newUser.email = "angelblue065@gmail.com"

        newUser.signUpInBackground(block: { (succeed, error) -> Void in
            

        })
    }
    
    @IBAction func loginClick(_ sender: UIButton) {
        
        view.endEditing(true)
        
        pfuserLogin()
    }
    
    func pfuserLogin() {
        
        let usernameText:String = accountTextField.text ?? ""
        
        let password:String = passwordTextField.text ?? ""
        
        let username = usernameText.trimmingCharacters(in: .whitespaces)
        
        if username == "" {
            
            showMessage("請輸入帳號", actions: nil)
            return
        }
        
        if password == "" {
            
            showMessage("請輸入密碼", actions: nil)
            return
        }
        
        let alert = showLoading()
        
        PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) -> Void in

            alert.dismiss(animated: false, completion: {
                
                if user != nil {
                    
                    let alertController = UIAlertController.init(title: "登入成功", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    self.present(alertController, animated: true, completion: {
                        
                        self.dismiss(animated: true, completion: {
                            
//                            self.dismiss(animated: true, completion: nil)
                            UIManager.switchToHomeVC()
                        })
                    })
                    
                } else {
                    
                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    
                    let alertController = UIAlertController.init(title: "密碼錯誤，或網路連線", message: "", preferredStyle: UIAlertController.Style.alert)
                    
                    alertController.addAction(action)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        })
    }
    
}
