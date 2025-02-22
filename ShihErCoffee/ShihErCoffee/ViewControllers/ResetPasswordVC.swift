//
//  ResetPasswordVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/3/15.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit

class ResetPasswordVC: CafeViewController {

    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
        mobileTextField.layer.borderColor = UIColor.coffieColor.cgColor
        
        passwordTextField.layer.borderColor = UIColor.coffieColor.cgColor
        
        mobileTextField.attributedPlaceholder = NSAttributedString(string: "手機號碼", attributes: [NSAttributedString.Key.foregroundColor: UIColor.coffieColor])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "簡訊認證碼", attributes: [NSAttributedString.Key.foregroundColor: UIColor.coffieColor])
    }

    @IBAction func doneClick(_ sender: UIButton) {
    
        performSegue(withIdentifier: "ResetPasswordTo", sender: nil)
    }
    
}
