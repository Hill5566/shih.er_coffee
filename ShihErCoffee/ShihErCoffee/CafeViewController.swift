//
//  CafeViewController.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/2/7.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class CafeViewController: UIViewController {
 
    let SPEND_QUERY_LIMIT = 100
    let STORED_QUERY_LIMIT = 100
    let RECORD_QUERY_LIMIT = 100
    let MEMBERSHIP_QUERY_LIMIT = 10000

    let mUser = UserDefaults.standard

    let myUserDefault = MyUserDefault()
    
    var shouldUpdateMembership = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        view.endEditing(true)
    }
    
    func getAllMemberships(showDeleted:Bool, completion:@escaping ([PFObject]) -> ()) {
      
        let query = PFQuery(className:Membership.className)
       
        let alert = showLoading(query: query)
        
        query.limit = MEMBERSHIP_QUERY_LIMIT
        
        query.whereKey(Membership.isDeleted, equalTo: showDeleted)
        
        query.order(byDescending: Membership.number)

        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            print("inside done")
            
            alert.dismiss(animated: true, completion: {
                
                if error == nil {
                    
                    if let objects = objects {
                        
                        completion(objects)
                        
                    } else {
                        
                        self.showMessage("get all memberships object error", actions: nil)
                    }
                    
                } else {
                    
                    self.showMessage("get all memberships error", actions: nil)
                }
            })
        }
    }
    
//    func queryMemberships(completion:@escaping ([PFObject]) -> ()) {
//
//        let query = PFQuery(className:Membership.className)
//
//        let alert = showLoading(query: query)
//
//        query.limit = MEMBERSHIP_QUERY_LIMIT
//
//        query.whereKey(Membership.isDeleted, equalTo: false)
//
//        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
//
//            print("inside done")
//
//            alert.dismiss(animated: true, completion: {
//
//                if error == nil {
//
//                    if let objects = objects {
//
//                        completion(objects)
//
//                    } else {
//
//                        self.showMessage("get all memberships object error", actions: nil)
//                    }
//
//                } else {
//
//                    self.showMessage("get all memberships error", actions: nil)
//                }
//            })
//        }
//    }

    func findNewMembershipNumber(completion:@escaping (Int) -> ()) {
        
        let query = PFQuery(className: Membership.className)
        
        query.order(byDescending: Membership.number)

        query.getFirstObjectInBackground { (object, error) in
            
            if error == nil {
                
                if let object = object {
                    
                    let number:Int = object[Membership.number] as! Int
                    
                    //TODO: check exist
                    completion(number+1)

                } else {
                    
                    self.showMessage("find new membership number object error: \(error!.localizedDescription)", actions: nil)
                }
                
            } else {
                
                self.showMessage("find new membership number error: \(error!.localizedDescription)", actions: nil)
            }
        }
    }
    
    //check member# exist
    func checkExist(key:String, value:String, completion:@escaping (Bool, PFObject?)->()) {
        
        let queryMemberMobile = PFQuery(className: Membership.className)
        
        queryMemberMobile.whereKey(key, equalTo: value)
        
        queryMemberMobile.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                guard let objects = objects else { return }
                
                if objects.count == 0 {
                    
                    completion(false, nil)
                    
                } else {
                    
                    completion(true, objects.first)
                }
                
            } else {
                
                self.showMessage("check exist error", actions: nil)
            }
        }
    }
    
    func addNewMembership(number:Int, name:String, birthdayYear: String, birthdayMonthDay: String, mobile:String, email:String, postCode:String, balance:Int, completion:@escaping (Bool, Error?) -> ()) {
        
        let membership = PFObject(className:Membership.className)
        
        membership[Membership.number] = number
        membership[Membership.name] = name
//        membership[Membership.birthday] = birthday
        membership[Membership.birthdayYear] = birthdayYear
        membership[Membership.birthdayMonthDay] = birthdayMonthDay
        membership[Membership.mobile] = mobile
        membership[Membership.postCode] = postCode
        membership[Membership.balance] = balance
        membership[Membership.isDeleted] = false
        membership[Membership.email] = email
        
        membership.saveInBackground {
            (success: Bool, error: Error?) in
            
            if success {
                
                self.addSystemLog(log: "AddMembership \(name)")
                
                self.addExpensesRecord(membership: membership, expend: 0, deposits: balance, balance: balance, completion: { (success, error) in
                    
                    completion(success, error)
                    
                })
            } else {
                
                self.showMessage("新增會員失敗", actions: nil)
            }
        }
    }
    
    func queryMembershipDetail(memberId:String, complete: @escaping (PFObject)-> ()) {
        
        let queryMembership = PFQuery(className: Membership.className)
        
        queryMembership.whereKey(Membership.objectId, equalTo: memberId)
        
        queryMembership.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                guard let objects = objects else { return }
                
                if objects.count == 0 {
                    
                    self.showMessage("query member by id, object count = 0", actions: nil)
                    
                } else {
                    
                    if let object = objects.first {
                        
                        complete(object)
                        
                    } else {
                        
                        self.showMessage("query balance error, object.first", actions: nil)
                    }
                }
                
            } else {
                
                self.showMessage("query member by id error", actions: nil)
            }
        }
    }
    
    func addExpensesRecord(membership:PFObject, expend:Int, deposits:Int, balance:Int, completion:@escaping (Bool, Error?) -> ()) {
        
        //TODO:動態抓取上一筆record的balance做計算，如下方的topup function
        let expensesRecord = PFObject(className:ExpensesRecord.className)
        
        expensesRecord[ExpensesRecord.membershipId] = membership
        
        let name:String = membership["name"] as? String ?? ""
        
        expensesRecord[ExpensesRecord.name] = name
        
        expensesRecord[ExpensesRecord.expend] = expend
        
        expensesRecord[ExpensesRecord.deposits] = deposits
        
        expensesRecord[ExpensesRecord.balance] = balance
        
        expensesRecord[ExpensesRecord.isDeleted] = false
        
        expensesRecord.saveInBackground {
            (success: Bool, error: Error?) in
            
            if success {
                
                if expend == 0 {
                    self.addSystemLog(log: "AddExpensesRecord \(name) deposits \(deposits)")
                } else if deposits == 0 {
                    self.addSystemLog(log: "AddExpensesRecord \(name) expend \(expend)")
                }
               
                let objectId = membership.objectId!
                
                self.updateBalance(membershipId: objectId, balance: balance, completion: { (success, error) in
                    
                    completion(success, error)
                })

            } else {
                
                self.showMessage("新增消費紀錄失敗", actions: nil)
            } 
        }
    }
    
    func queryExpensesRecord(membership:PFObject, queryLimit:Int, complete: @escaping ([PFObject]) -> ()) {
        
        let queryMembership = PFQuery(className: ExpensesRecord.className)
                
        queryMembership.whereKey(ExpensesRecord.membershipId, equalTo: membership)

        queryMembership.whereKey(ExpensesRecord.isDeleted, equalTo: false)
        
        queryMembership.order(byDescending: ExpensesRecord.createdAt)
        
        queryMembership.limit = queryLimit
        
        queryMembership.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                guard let objects = objects else { return }
                
                    complete(objects)
                
            } else {
                
                self.showMessage("queryExpensesRecord error", actions: nil)
            }
        }
    }
    
    func topupCoin(toMembershipObjectId membershipObjectId:String, chargeCoin:Double, completion: @escaping () -> ()) {
        
        queryBalance(memberId: membershipObjectId) { (currentCoin) in
            
            let currentBalance:Double = currentCoin
            
            let newBalance:Double = currentBalance + chargeCoin
            
            let membershipAddCoin = PFObject(withoutDataWithClassName: Membership.className, objectId: membershipObjectId)
            
            membershipAddCoin[Membership.balance] = newBalance
            
            membershipAddCoin.saveInBackground { (success, error) in
                
                if error == nil {
                    
                    completion()
                    
                } else {
                    
                    self.showMessage("add coin error", actions: nil)
                }
            }
        }
    }
    
    func updateBalance(membershipId:String, balance:Int, completion:@escaping (Bool, Error?) -> ()) {
        
        let membershipClass = PFObject(withoutDataWithClassName: Membership.className, objectId: membershipId)
        
        membershipClass[Membership.balance] = balance
        
        membershipClass.saveInBackground { (success, error) in
            
            completion(success, error)
        }
    }
    func newUpdate(membershipClass: PFObject) {
        membershipClass.saveInBackground { (success, error) in
            if success {
                self.showMessage("修改成功", actions: nil)
            } else {
                self.showMessage("修改失敗", actions: nil)
            }
        }
    }
    func update(memberEditableField:MemberEditableField, editContent:String, byMembershipId membershipId:String) {
        
        let membershipClass = PFObject(withoutDataWithClassName: Membership.className, objectId: membershipId)

        switch memberEditableField {
        case MemberEditableField.Gender:
          
            membershipClass[Membership.gender] = editContent
        
        case MemberEditableField.Birthday:
          
            membershipClass[Membership.birthday] = editContent
       
        case MemberEditableField.PhoneNumber:

            membershipClass[Membership.mobile] = editContent

        case MemberEditableField.Email:
          
            membershipClass[Membership.email] = editContent
      
        case MemberEditableField.FavoriteItem:
            
            membershipClass[Membership.favoriteItem] = editContent
        
        case .Name:
            
            membershipClass[Membership.name] = editContent
        }
        
        membershipClass.saveInBackground { (success, error) in
            
            if success {
                self.showMessage("修改 \(editContent) 成功", actions: nil)
            } else {
                self.showMessage("修改 \(editContent) 失敗", actions: nil)
            }
        }
    }
    
    func deleteMembership(membershipId:String, isDeleted:Bool, completion:@escaping (Bool, Error?) -> ()) {
        
        let membershipClass = PFObject(withoutDataWithClassName: Membership.className, objectId: membershipId)

        membershipClass[Membership.isDeleted] = isDeleted
        
        membershipClass.saveInBackground { (success, error) in
            
            completion(success, error)
        }
    }
    
    func deleteExpensesRecord(membershipId:String, memberName:String, recordId:String, isDeleted:Bool, deposits:String, expend:String, balance:Int, completion:@escaping (Bool, Error?) -> ()) {
        
        let recordClass = PFObject(withoutDataWithClassName: ExpensesRecord.className, objectId: recordId)
        
        recordClass[ExpensesRecord.isDeleted] = isDeleted
        
        recordClass.saveInBackground { (success, error) in
            
            if success {
                
                var message = ""
                
                if deposits == "0" {
                    message = "expend \(expend)"
                }
                
                if expend == "0" {
                    message = "deposits \(deposits)"
                }
                
                self.addSystemLog(log: "DeleteExpensesRecord \(memberName) \(message)")
                
                self.updateBalance(membershipId: membershipId, balance: balance, completion: { (success, error) in
                    
                    completion(success, error)
                })
            } else {
                
                completion(success, error)
            }
        }
    }
    
    func queryBalance(memberId:String, completion: @escaping (Double) -> ()) {
        
        let queryBalance = PFQuery(className: Membership.className)
        
        queryBalance.whereKey(Membership.objectId, equalTo: memberId)
        
        queryBalance.findObjectsInBackground { (objects, error) in
        
            if error == nil {
                
                guard let objects = objects else { return }
                
                if objects.count == 0 {
                    
                    self.showMessage("no member object id", actions: nil)
                    
                } else {
                    
                    if let object = objects.first {
                        
                        let membershipDetail:[String:String] = self.transMembershipPFObjectToString(membership: object)
                        
                        let coinString:String = membershipDetail[Membership.balance]!
                        
                        if let coin = Double(coinString) {
                            
                            completion(coin)
                            
                        } else {
                            
                            self.showMessage("coinstring error", actions: nil)
                        }
                        
                    } else {
                        
                        self.showMessage("query balance error, object.first", actions: nil)
                    }
                }
                
            } else {
                
                self.showMessage("query balance error", actions: nil)
            }
        }
    }
    
    func queryGoods(completion: @escaping ([PFObject], Error?) -> ()) {
        
        let coffieQuery = PFQuery(className: CoffieSubclassing.parseClassName())
        let alert = showLoading(query: coffieQuery)
        coffieQuery.findObjectsInBackground { (objects, error) in
            
            alert.dismiss(animated: true, completion: {
                guard let objects = objects else {
                    self.showMessage("網路異常", actions: nil)
                    return
                }
                completion(objects, error)
            })
        }
    }
    
    func addSystemLog(log:String) {
        
        let systemLog = PFObject(className: "SystemLog")
        
        systemLog["log"] = log
        
        systemLog.saveInBackground { (success, error) in
            
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
    
    func transMembershipPFObjectToString(membership:PFObject) -> [String:String] {
                
        var objectId:String  = ""
        var number:String    = "???"
        var name:String      = ""
        var mobile:String    = ""
        var balance:String   = ""
        var birthdayYear:String  = ""
        var birthdayMonthDay:String  = ""
        var birthday:String  = ""
        var postCode:String  = ""
        var specialGuest:String = "false"
        
        var gender:String = ""
        var email = ""
        var favoriteItem = ""
        
        if let objId = membership.objectId {
            
            objectId = objId
        }

        if membership[Membership.number] is Int {
            
            number = String(describing: membership[Membership.number] as! Int)
        }
        
        if membership[Membership.name] is String {
            
            name = membership[Membership.name] as! String
        }

        if membership[Membership.mobile] is String {
            
            mobile = membership[Membership.mobile] as! String
        }
        
        if membership[Membership.balance] is Double {
            
            balance = String(describing: membership[Membership.balance] as! Double)
        }
        
        if membership[Membership.birthdayYear] is String {
                    
            birthdayYear = membership[Membership.birthdayYear] as! String
        }
        
        if membership[Membership.birthdayMonthDay] is String {
                    
            birthdayMonthDay = membership[Membership.birthdayMonthDay] as! String
        }
        
        if membership[Membership.birthday] is String {
            
            birthday = membership[Membership.birthday] as! String
        }
        
        if membership[Membership.postCode] is String {
            
            postCode = membership[Membership.postCode] as! String
        }
        
        if membership[Membership.specialGuest] is Bool {
            
            specialGuest = "true"
        }
        
        if membership[Membership.gender] is String {
            
            gender = membership[Membership.gender] as! String
        }
        if membership[Membership.email] is String {
            
            email = membership[Membership.email] as! String
        }
        if membership[Membership.favoriteItem] is String {
            
            favoriteItem = membership[Membership.favoriteItem] as! String
        }
        
        return [Membership.number:number,
                Membership.name:name,
                Membership.mobile:mobile,
                Membership.balance:balance,
                Membership.birthdayYear:birthdayYear,
                Membership.birthdayMonthDay:birthdayMonthDay,
                Membership.birthday:birthday,
                Membership.postCode:postCode,
                Membership.objectId:objectId,
                Membership.specialGuest:specialGuest,
                Membership.gender:gender,
                Membership.email:email,
                Membership.favoriteItem:favoriteItem
        ]
    }
    
    func transExpensesPFObjectToString(expensesRecord:PFObject) -> [String:String] {
        
        let objectId:String = { if let objId = expensesRecord.objectId { return objId } else { return "" } }()
        
        let expend:String = {
            if let balanceDouble = expensesRecord[ExpensesRecord.expend] as? Int {
                return "\(balanceDouble)"
            } else {
                return ""
            }
        }()
        
        let deposits:String = {
            if let balanceDouble = expensesRecord[ExpensesRecord.deposits] as? Int {
                return "\(balanceDouble)"
            } else {
                return ""
            }
        }()
        
        let balance:String = {
            if let balanceDouble = expensesRecord[ExpensesRecord.balance] as? Int {
                return "\(balanceDouble)"
            } else {
                return ""
            }
        }()

        let updateAt:String = {
            if let updateDate = expensesRecord.updatedAt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                return dateFormatter.string(from: updateDate)
            } else {
                return ""
            }
        }()
        
        
        return [ExpensesRecord.expend:expend,
                ExpensesRecord.deposits:deposits,
                ExpensesRecord.balance:balance,
                ExpensesRecord.objectId:objectId,
                ExpensesRecord.updatedAt:updateAt]
    }
    
    func showMessage(_ message: String, actions: [UIAlertAction]?) {
        
        UIApplication.shared.endIgnoringInteractionEvents()
        
        let messageAlert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        if let actions = actions {
            
            for action in actions {
                
                messageAlert.addAction(action)
            }
        } else {
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            messageAlert.addAction(action)
        }
        
        self.present(messageAlert, animated: true, completion: nil)
    }
}

//#pragma mark - Common Function
extension CafeViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func make6Secret() -> Int {
        
        var r:Int = Int(arc4random() % 1000000);
        
        while (r < 100000) {
            
            r = Int(arc4random() % 1000000);
            
        }
        return r;
    }
    
    func showLoading() -> UIAlertController {
        
        print(#function)
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: false, completion: nil)
        
        return alert
    }
    
    func showLoading(query:PFQuery<PFObject>) -> UIAlertController {
        
        print(#function)
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in
            print("cancel")
            query.cancel()
        }
        
        alert.addAction(cancelAction)
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: false, completion: nil)
        
        return alert
    }
}

extension CafeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func setCafeTextField(_ textField: UITextField, placeHolderString:String) {
        
        textField.layer.borderColor = UIColor.coffieColor.cgColor
        
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.coffieColor])        
    }
    
    func setCafeButton(_ button: UIButton) {
        
//        button.layer.borderWidth = 1
        button.layer.cornerRadius = 21
        
    }
    
    func setCafeLabel(_ label: UILabel, text: String) {
        
        label.layer.cornerRadius = 21
        
        label.layer.borderWidth = 1
        
        label.layer.borderColor = UIColor.white.cgColor
        
        label.text = text
    }
}

// MARK: - ShowAlert
extension CafeViewController {
    func showAlertByOneButton(title: String?,
                              message: String?,
                              actionTitle: String,
                              action: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: actionTitle, style: .default, handler: action)
            alertController.addAction(action)
            self.showAlertController(alertController)
        }
    }
    
    func showAlertByTwoButton(title: String?,
                              message: String?,
                              leftTitle: String,
                              leftStyle: UIAlertAction.Style = .default,
                              rightTitle: String,
                              rightStyle: UIAlertAction.Style = .default,
                              leftAction: ((UIAlertAction) -> Void)? = nil,
                              rightAction: ((UIAlertAction) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let leftAlertAction = UIAlertAction(title: leftTitle, style: leftStyle, handler: leftAction)
            alertController.addAction(leftAlertAction)
            
            let rightAlertAction = UIAlertAction(title: rightTitle, style: rightStyle, handler: rightAction)
            alertController.addAction(rightAlertAction)
            
            self.showAlertController(alertController)
        }
    }
    
    fileprivate func showAlertController(_ alertController: UIAlertController) {
        if var topVC = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedVC = topVC.presentedViewController {
                topVC = presentedVC
            }
            topVC.present(alertController, animated: true, completion: nil)
        } else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
