//
//  BankVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/2/17.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit

protocol BankDelegate {
    
    func transactionComplete()
}

class BankVC: CafeViewController {

    var delegate:BankDelegate?
    var name:String?
    var balance:String?
    var memberId:String?
    
    var basicCoin:String = "1000"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var topupTextField: UITextField!
    
    @IBOutlet weak var spendTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
        self.tabBarController?.tabBar.isHidden = true
        
        guard let name = name, let balance = balance else {
            
            self.showMessage("資料錯誤", actions: nil)
            return
        }
        
        nameLabel.text = "\(name)"
        
        balanceLabel.text = "\(balance.components(separatedBy: ".")[0])"
        
        topupTextField.text = basicCoin
        
        spendTextField.becomeFirstResponder()
    }
    
    @IBAction func topupClick(_ sender: Any) {
        
        guard let memberId = memberId else {
            
            let backAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                self.navigationController?.popViewController(animated: false)
            })
            
            showMessage("id資料錯誤", actions: [backAction])
            return
        }
        
        guard let coin:Double = Double(topupTextField.text!)  else {
            
            let backAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                self.navigationController?.popViewController(animated: false)
            })
            
            showMessage("錯誤金額", actions: [backAction])
            return
        }
        
        topupCoin(toMembershipObjectId: memberId, chargeCoin: coin, completion: {
            
            self.delegate?.transactionComplete()
            
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func spendClick(_ sender: UIButton) {
        
        guard let memberId = memberId else {
            
            let backAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                self.navigationController?.popViewController(animated: false)
            })
            
            showMessage("id資料錯誤", actions: [backAction])
            return
        }
        
        guard let spendCoin:Double = Double(spendTextField.text!)  else {
            
            let backAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                self.navigationController?.popViewController(animated: false)
            })
            
            showMessage("錯誤金額", actions: [backAction])
            return
        }
        
        guard let balance = balance else {
            
            self.showMessage("餘額資料錯誤", actions: nil)
            return
        }
            
        if let balance:Double = Double(balance) {
            
            if spendCoin > balance {
                
                self.showMessage("餘額不足", actions: nil)
                
            } else {
                
                topupCoin(toMembershipObjectId: memberId, chargeCoin: -spendCoin, completion: {
                    
                    self.delegate?.transactionComplete()
                    
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
        } else {
            
            self.showMessage("＃資料錯誤", actions: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //讓鍵盤無法點空白dismiss
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //讓鍵盤return無法點空白dismiss
        return true
    }
}
