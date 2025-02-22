//
//  SpendVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/5/31.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class SpendVC: CafeViewController {

    public var goStoreCallback: ((String) -> ())?

    var membershipExpensesRecord:[PFObject]?
    
    var membershipDetail:PFObject?
    
    var memberId:String?
    
    var balance:Int = 0

    //    var delegate:BankDelegate?
    
    @IBOutlet weak var lastSpendTimeLaftLabel: UILabel!
    
    @IBOutlet weak var lastSpendTimeLabel: UILabel!
    
    @IBOutlet weak var balanceLeftLabel: UILabel!
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var spendCoinLeftLabel: UILabel!
    
    @IBOutlet weak var spendCoinTextField: UITextField! {
        didSet {
            spendCoinTextField.layer.borderWidth = 1
            spendCoinTextField.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
        let memberDetail = transMembershipPFObjectToString(membership: membershipDetail!)
        
        navigationItem.title = memberDetail[Membership.name]
        
        setCafeLabel(lastSpendTimeLaftLabel, text: "上次消費時間")
        setCafeLabel(balanceLeftLabel, text: "餘額")
        setCafeLabel(spendCoinLeftLabel, text: "消費金額")
        
        spendCoinTextField.tintColor = UIColor.white
        
        setCafeButton(addButton)
        
        if let membershipExpensesRecord = membershipExpensesRecord {
            
            setMembershipData(records: membershipExpensesRecord)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        spendCoinTextField.becomeFirstResponder()
    }
    
    func setMembershipData(records:[PFObject]) {
        
        for record in records {
            
            let mRecord = transExpensesPFObjectToString(expensesRecord: record)
            
            if mRecord[ExpensesRecord.deposits] == "0" {
                
                lastSpendTimeLabel.text = mRecord[ExpensesRecord.updatedAt]
                
                break
                
            } else {
                
                lastSpendTimeLabel.text = "尚未"
            }
        }
        
        guard let record = records.first else { balanceLabel.text = "0"; return }
        
        let mRecord = transExpensesPFObjectToString(expensesRecord: record)
        
        balanceLabel.text = mRecord[ExpensesRecord.balance]
        
        guard let balanceString = mRecord[ExpensesRecord.balance] else {return}
        
        guard let balanceInt = Int(balanceString) else {return}
            
        balance = balanceInt

        print("return record")
    }
    
    @IBAction func confirmClick(_ sender: Any) {
        
        guard let spendCoinString = spendCoinTextField.text else {return}
        
        guard let spendCoin:Int = Int(spendCoinString) else {return}

//        if balance < coin {
//
//            showMessage("餘額不足", actions: nil)
//            return
//        }
//
        if spendCoin <= 0 {

            showMessage("錯誤金額", actions: nil)
            return
        }
        
        if spendCoin > 1000 {
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            let okAction = UIAlertAction(title: "確定", style: .default, handler: { (alert) in
                
                self.addRecord(balance: self.balance, coin: spendCoin)
            })
            
            showMessage("金額超過1000，確定？", actions: [cancelAction, okAction])
            
        } else {
            
            addRecord(balance: balance, coin: spendCoin)
        }
    }
    
    func addRecord(balance:Int, coin:Int) {
        
        guard let membershipDetail = membershipDetail else {return}

        let mBalance = balance - coin
        
        let alert = showLoading()
        
        addExpensesRecord(membership: membershipDetail, expend: coin, deposits: 0, balance: mBalance) { (success, error) in
            
            alert.dismiss(animated: false, completion: {
                
                if success {
                    
                    let action = UIAlertAction(title: "回消費", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })

                    let goStore = UIAlertAction(title: "去儲值頁", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: false)
                        
                        let memberDetail = self.transMembershipPFObjectToString(membership: membershipDetail)
                        let mobile = memberDetail[Membership.mobile]
                        
                        self.goStoreCallback?(mobile ?? "")
                    })
                    
                    self.showMessage("消費 \(coin) 元，餘額 \(mBalance) 元", actions: [action, goStore])
                    
                } else {
                    
                    self.showMessage("addExpensesRecord error", actions: nil)
                }
            })
        }
    }
    
    @IBAction func rightBarButtonClick(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: AppSegue.spendVCToMembershipDetailVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! MembershipDetailVC
        
        vc.membershipDetail = membershipDetail
        
        vc.recordDelegate = self
    }
}

extension SpendVC: RecordDelegate {
    
    func deleteComplete(balance: Int) {
        
        let balanceString = "\(balance)"
        
        balanceLabel.text = balanceString
        
        self.balance = balance
        
        if membershipDetail != nil {
            
            membershipDetail![Membership.balance] = balance
        }
    }
}
