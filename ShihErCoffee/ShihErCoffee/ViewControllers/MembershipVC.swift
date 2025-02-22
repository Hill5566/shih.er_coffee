//
//  MainVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/2/8.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class MembershipVC: CafeViewController {
    public var fromWhichFunction:HomeFunction = .memberData
    
    enum Reverse {
        case number, birthday
    }
    private var reverseType: Reverse = .number
    
    @IBOutlet weak var numberOrderButton: UIButton!
    @IBOutlet weak var birthdayOrderButton: UIButton!

    @IBAction func sortNumberClick(_ sender: UIButton) {
        numberOrderButton.isSelected = false
        birthdayOrderButton.isSelected = false
        sender.isSelected = true

        switch reverseType {
        case .number:
            membershipsFiltered = membershipsFiltered.reversed()
            
        case .birthday:
            membershipsFiltered = membershipsAll
        }
        
        reverseType = .number
        reloadTableView()
    }
    
    @IBAction func sortBirthday(_ sender: UIButton) {
        numberOrderButton.isSelected = false
        birthdayOrderButton.isSelected = false
        sender.isSelected = true
        
        switch reverseType {
        case .number:
            membershipsFiltered.sort {
                if let birthday0 = $0[Membership.birthdayMonthDay], let birthday1 = $1[Membership.birthdayMonthDay] {
                    let stringBirthday0 = birthday0.replacingOccurrences(of: "/", with: "")
                    let intBirthday0: Int = Int(stringBirthday0) ?? 0
                    
                    let stringBirthday1 = birthday1.replacingOccurrences(of: "/", with: "")
                    let intBirthday1: Int = Int(stringBirthday1) ?? 0
                    print(intBirthday0, intBirthday1)
                    return intBirthday1 > intBirthday0
                } else {
                    return false
                }
            }
            
        case .birthday:
            membershipsFiltered = membershipsFiltered.reversed()
        }
        
        reverseType = .birthday
        reloadTableView()
    }
    
    @IBOutlet weak var mQueryTextField: UITextField! {
        didSet {
            mQueryTextField.leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
            imageView.image = UIImage(named: "icons8-search")
            mQueryTextField.leftView = imageView
            mQueryTextField.attributedPlaceholder = NSAttributedString(string: "輸入關鍵字", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
    @IBOutlet weak var mTableView: UITableView!
    
    var membershipPFObjects:[PFObject] = []
    var selectedMembership:PFObject?
    var membershipsAll:[[String:String]] = []
    var membershipsFiltered:[[String:String]] = []
    
    var numberSorting:Bool = false
    //deprecated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
        
        navigationItem.title = fromWhichFunction.rawValue
        
        refreshMemberships(showDeleted: false)
        
        setOrderButtonsDisplay()
    }
    
    private func setOrderButtonsDisplay() {
        reverseType = .number
        numberOrderButton.isSelected = true
        birthdayOrderButton.isSelected = false
    }
    
    @IBAction func refreshClick(_ sender: UIBarButtonItem) {
        
        mQueryTextField.text = ""
        
        refreshMemberships(showDeleted: false)
    }
        
//    @IBAction func mSwitchHiddenMember(_ sender: UISwitch) {
//
//        refreshMemberships(isDeleted: !sender.isOn)
//    }
    
    @IBAction func filterTextFieldEditingChanged(_ sender: UITextField) {
        
        guard let text = sender.text else { return }
        if text == "" {
            membershipsFiltered = membershipsAll
            reloadTableView()
            return
        }
        
        let inputText:String = text.uppercased()
        
        var tmpMemberships:[[String:String]] = []
        
        for membership in membershipsAll {
            
            for key in membership.keys {
                
                if key == Membership.name || key == Membership.mobile || key == Membership.number || key == Membership.birthday {

                    if membership[key]!.uppercased().contains(inputText)  {

                        tmpMemberships.append(membership)
                        break
                    }
                }
            }
        }
        
        membershipsFiltered = tmpMemberships

        reloadTableView()
    }
    
    func refreshMemberships(showDeleted:Bool) {
        
        getAllMemberships(showDeleted: showDeleted) { (objects) in
            
            self.membershipPFObjects = objects
            
            self.membershipsAll = []
            
            self.membershipsFiltered = []
            
            for member in objects {
                
                self.membershipsFiltered.append(self.transMembershipPFObjectToString(membership: member))
            }
            
            self.membershipsAll = self.membershipsFiltered.reversed()
            
            self.filterTextFieldEditingChanged(self.mQueryTextField)
        }
    }
    
    @IBAction func headerClick(_ sender: UIButton) {
        //deprecated
        numberSorting = !numberSorting
        
        view.endEditing(true)
        
        membershipsFiltered.reverse()
        
        mTableView.reloadData()
    }
}

extension MembershipVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return membershipsFiltered.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell:MainMembershipTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainMembershipTableViewCell
//
//        cell.bankButton.tag = indexPath.row
//
//        cell.bankButton.layer.cornerRadius = 6
//
//        cell.bankButton.layer.borderWidth = 1
//
//        cell.bankButton.addTarget(self, action: #selector(bankClick(_:)), for: .touchUpInside)
//
//        if indexPath.row % 2 == 0 {
//
//            cell.backgroundColor = UIColor.cafeColor3
//
//            cell.bankButton.layer.borderColor = UIColor.white.cgColor
//
//        } else {
//
//            cell.backgroundColor = UIColor.white
//
//            cell.bankButton.layer.borderColor = UIColor.cafeColor6.cgColor
//        }
//
//        cell.number.text = "# " + membershipsFiltered[indexPath.row][Membership.number]!
//
//        cell.name?.text = membershipsFiltered[indexPath.row][Membership.name]
//
//        cell.mobile?.text = membershipsFiltered[indexPath.row][Membership.mobile]
//
//        cell.balance?.text = membershipsFiltered[indexPath.row][Membership.balance]?.components(separatedBy: ".")[0]
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MainMembershipTableViewCell
        
        let member = membershipsFiltered[indexPath.row]
        
        cell.number.text = "#\(String(describing: member[Membership.number] ?? ""))"
        cell.name.text = member[Membership.name]
        cell.mobile.text = member[Membership.mobile]
        
        let newBirthdayYear = member[Membership.birthdayYear] ?? ""
        let newBirthdayMonthDay = member[Membership.birthdayMonthDay] ?? ""
        if newBirthdayYear.isEmpty, newBirthdayMonthDay.isEmpty {
            cell.newBirthday.text = ""
        } else {
            cell.newBirthday.text = newBirthdayYear + "/" + newBirthdayMonthDay
        }
        
        let birthday = member[Membership.birthday] ?? ""
        cell.birthday.isHidden = birthday.isEmpty ? true : false
        cell.birthday.text = "舊: " + birthday
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select row at \(indexPath.row)")
        
        let membership = membershipsFiltered[indexPath.row]
        
        let membershipId = membership[Membership.objectId]
        
        for object in membershipPFObjects {
            
            guard let objectId = object.objectId else {return}
            
            if membershipId == objectId {
                
                selectedMembership = object
            }
        }
        
//        let memberId:String = membershipsFiltered[indexPath.row][Membership.objectId]!
        
        guard let selectedMembership = selectedMembership else {return}
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        view.endEditing(true)
        switch fromWhichFunction {
        case .stored:
            
            queryExpensesRecord(membership: selectedMembership, queryLimit: STORED_QUERY_LIMIT) { (pfObjects) in
                UIApplication.shared.endIgnoringInteractionEvents()
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "StoredVC") as! StoredVC
                vc.membershipExpensesRecord = pfObjects
                vc.membershipDetail = selectedMembership
                vc.goSpendCallback = { mobile in
                    self.fromWhichFunction = .spend
                    self.mQueryTextField.text = mobile
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .spend:
            
            queryExpensesRecord(membership: selectedMembership, queryLimit: SPEND_QUERY_LIMIT) { (pfObjects) in
                UIApplication.shared.endIgnoringInteractionEvents()
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "SpendVC") as! SpendVC
                vc.membershipExpensesRecord = pfObjects
                vc.membershipDetail = selectedMembership
                vc.goStoreCallback = { mobile in
                    self.fromWhichFunction = .stored
                    self.mQueryTextField.text = mobile
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .memberData:
            UIApplication.shared.endIgnoringInteractionEvents()
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "MembershipDetailVC") as! MembershipDetailVC
            vc.membershipDetail = selectedMembership
            self.navigationController?.pushViewController(vc, animated: true)
//            queryMembershipDetail(memberId: memberId) { (pfObjects) in
//                UIApplication.shared.endIgnoringInteractionEvents()
//                let vc = self.storyboard!.instantiateViewController(withIdentifier: "MembershipDetailVC") as! MembershipDetailVC
//                vc.membershipDetail = pfObjects
//                vc.membershipDetail = selectedMembership
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 42
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        //deprecated numberSorting
//        let headerCell:MainHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! MainHeaderTableViewCell
//        if numberSorting {
//            headerCell.sortingImageView.image = UIImage.init(named: "icons8-generic_sorting")
//        } else {
//            headerCell.sortingImageView.image = UIImage.init(named: "icons8-generic_sorting_2")
//        }
//        return headerCell
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 0
//        return 44
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            showAlertByTwoButton(title: "刪除?", message: nil, leftTitle: "先不要", leftStyle: .cancel, rightTitle: "刪除", rightStyle: .default) { _ in
                
            } rightAction: { _ in
                self.hideMembership(indexPath: indexPath)
            }
        }
    }
    
    func hideMembership(indexPath: IndexPath) {
        guard let membershipId = membershipsFiltered[indexPath.row][Membership.objectId] else {
            
            showMessage("刪除錯誤", actions: nil)
            return
        }
        
        let alert = showLoading()
        
        deleteMembership(membershipId: membershipId, isDeleted: true) { (success, error) in
            
            alert.dismiss(animated: false, completion: {
                
                if success {
                    
                    if let memberName = self.membershipsFiltered[indexPath.row][Membership.name] {
                        self.addSystemLog(log: "DeleteMembership \(memberName)")
                    }
                    
                    let mobile = self.membershipsFiltered[indexPath.row][Membership.mobile]
                    
                    for (index, membership) in self.membershipsAll.enumerated() {
                        
                        if mobile == membership[Membership.mobile] {
                            
                            self.membershipsAll.remove(at: index)
                            break
                        }
                    }
                    
                    self.membershipsFiltered.remove(at: indexPath.row)
                    
                    self.mTableView.reloadData()
                    
                } else {
                    
                    self.showMessage("刪除失敗", actions: nil)
                }
            })
        }
    }
    
//    @objc func bankClick(_ sender:UIButton) {
//        //deprecated numberSorting
//        performSegue(withIdentifier: AppSegue.membershipVCToStoredVC, sender: sender)
//    }
}


extension MembershipVC {
    func reloadTableView() {
        UIView.transition(with: mTableView,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.mTableView.reloadData()
        })
    }
}
