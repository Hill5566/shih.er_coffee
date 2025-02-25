//
//  StoredVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/5/30.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class StoredVC: CafeViewController {

    public var goSpendCallback:((String)->())?
    public var membershipExpensesRecord:[PFObject]?
    public var membershipDetail:PFObject?
    
    private var defaultPlans = ["500", "1000"]
    private var currentPlans:[String] = []
    private var balance:Int = 0
//    var delegate:BankDelegate?
    @IBOutlet weak var lastStoredTimeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var editChargeNumber: UIButton!
    @IBAction func editChargeNumberClick(_ sender: UIButton) {
       
        let vc = UIStoryboard(name: "Transaction", bundle: nil).instantiateViewController(withIdentifier: "EditTopUpPlansVC") as! EditTopUpPlansVC
        
        vc.plans = UserSetting.default.loadStoredPlans() ?? defaultPlans
        vc.changedPlansCallback = {
            self.currentPlans = UserSetting.default.loadStoredPlans() ?? self.defaultPlans
            self.mSegmentedControl.replaceSegments(segments: self.currentPlans)
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var mSegmentedControl: UISegmentedControl! {
        didSet {
            currentPlans = UserSetting.default.loadStoredPlans() ?? defaultPlans
            mSegmentedControl.replaceSegments(segments: currentPlans)
        }
    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        let currentIndex = sender.selectedSegmentIndex
        storedCoinTextField.text = currentPlans[currentIndex]
    }
    
    @IBOutlet weak var storedCoinTextField: UITextField! {
        didSet {
            storedCoinTextField.layer.borderWidth = 1
            storedCoinTextField.layer.borderColor = UIColor.white.cgColor
            storedCoinTextField.tintColor = UIColor.white
        }
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
        let memberDetail = transMembershipPFObjectToString(membership: membershipDetail!)
        
        navigationItem.title = memberDetail[Membership.name]

        lastStoredTimeLabel.text = "尚未"
        
        balanceLabel.text = "0"
        
        setCafeButton(addButton)
        editChargeNumber.layer.cornerRadius = 4

        if let membershipExpensesRecord = membershipExpensesRecord {

            setRecordspData(records: membershipExpensesRecord)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        storedCoinTextField.becomeFirstResponder()
    }

    func setRecordspData(records:[PFObject]) {
        
        for record in records.reversed() {
            
            let mRecord = transExpensesPFObjectToString(expensesRecord: record)
            
            if mRecord[ExpensesRecord.expend] == "0" {
                                
                lastStoredTimeLabel.text = mRecord[ExpensesRecord.updatedAt]
                
                break
                
            } else {
               
                
            }
        }
        
        guard let record = records.first else { balanceLabel.text = "0"; return }
        
        let mRecord = transExpensesPFObjectToString(expensesRecord: record)

        balanceLabel.text = mRecord[ExpensesRecord.balance]
        
        guard let balanceString = mRecord[ExpensesRecord.balance] else { return }
        
        guard let balanceInt = Int(balanceString) else { return }
        
        balance = balanceInt
    }
    
    @IBAction func confirmClick(_ sender: Any) {
        
        guard let coinString:String = storedCoinTextField.text else {return}
        
        guard let coin:Int = Int(coinString) else {
            showMessage("未輸入金額", actions: nil)
            return
        }
        
        if coin <= 0 {
            showMessage("錯誤金額", actions: nil)
            return
        }
        
        addRecord(balance: balance, coin: coin)
        
//        if coin > 10000 {
//
//            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//
//            let okAction = UIAlertAction(title: "確定", style: .default, handler: { (alert) in
//
//                self.addRecord(balance: self.balance, coin: coin)
//            })
//
//            showMessage("金額超過10000，確定？", actions: [cancelAction, okAction])
//
//        } else {
//
//            addRecord(balance: balance, coin: coin)
//        }
    }
    
    func addRecord(balance:Int, coin:Int) {
        
        guard let membershipDetail = membershipDetail else {return}

        let mBalance = balance + coin
        
        let alert = showLoading()
        
        addExpensesRecord(membership: membershipDetail, expend: 0, deposits: coin, balance: mBalance) { (success, error) in
            
            alert.dismiss(animated: false, completion: {
                
                if success {
                    
                    let ok = UIAlertAction(title: "回上頁", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    let goSpend = UIAlertAction(title: "去消費頁", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: false)
                        
                        let memberDetail = self.transMembershipPFObjectToString(membership: membershipDetail)
                        let mobile = memberDetail[Membership.mobile]
                        
                        self.goSpendCallback?(mobile ?? "")
                    })
                    self.showMessage("儲值 \(coin) 元, 餘額 \(mBalance) 元", actions: [ok, goSpend])
                    
                } else {
                    
                    self.showMessage("addExpensesRecord error", actions: nil)
                }
            })
        }
    }
    
    @IBAction func rightBarButtonClick(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: AppSegue.storedVCToMembershipDetailVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! MembershipDetailVC
        
        vc.membershipDetail = membershipDetail
        vc.callback = { balance in
            self.balance = balance
        }
        vc.recordDelegate = self
    }
}

extension StoredVC: RecordDelegate {
    
    func deleteComplete(balance: Int) {
        
        let balanceString = "\(balance)"
        
        balanceLabel.text = balanceString
        
        if membershipDetail != nil {
            
            membershipDetail![Membership.balance] = balance
        }
    }
}

extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
