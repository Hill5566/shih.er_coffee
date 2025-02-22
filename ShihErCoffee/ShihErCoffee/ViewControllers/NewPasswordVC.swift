//
//  NewPasswordVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/3/15.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit

class NewPasswordVC: CafeViewController {

    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        mobileTextField.layer.borderColor = UIColor.coffieColor.cgColor
        
        passwordTextField.layer.borderColor = UIColor.coffieColor.cgColor
        
        mobileTextField.attributedPlaceholder = NSAttributedString(string: "密碼", attributes: [NSAttributedString.Key.foregroundColor: UIColor.coffieColor])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "確認證碼", attributes: [NSAttributedString.Key.foregroundColor: UIColor.coffieColor])
        
    }

}
