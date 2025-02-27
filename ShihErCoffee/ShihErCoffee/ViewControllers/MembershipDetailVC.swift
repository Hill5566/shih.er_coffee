//
//  ViewController.swift
//  CafeCoinClient
//
//  Created by Lin Hill on 2018/2/8.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

protocol RecordDelegate {
    
    func deleteComplete(balance:Int)
}

class MembershipDetailVC: CafeViewController {
    enum PickerType {
        case year, monthDay
    }
    let pickerView = UIPickerView()
    var pickerType: PickerType = .year
    
    let years: [String] = ["1912", "1913", "1914", "1915", "1916", "1917", "1918", "1919", "1920", "1921", "1922", "1923", "1924", "1925", "1926", "1927", "1928", "1929", "1930", "1931", "1932", "1933", "1934", "1935", "1936", "1937", "1938", "1939", "1940", "1941", "1942", "1943", "1944", "1945", "1946", "1947", "1948", "1949", "1950", "1951", "1952", "1953", "1954", "1955", "1956", "1957", "1958", "1959", "1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024"].reversed()
    let months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    let days = [
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
    ]
    
    var callback:((Int)->())?
    
    var isMyEditing:Bool = false //確定有修改流程完成才能點別的textField
    
    var recordDelegate:RecordDelegate?
    
    var membershipDetail:PFObject?
    var expenses:[[String:String]] = []
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthDayTextField: UITextField!
//    @IBOutlet weak var mGenderLabel: UILabel!
//    @IBOutlet weak var mBirthdayLabel: UILabel!
//    @IBOutlet weak var mMobileLabel: UILabel!
//    @IBOutlet weak var mEmailLabel: UILabel!
//    @IBOutlet weak var mFavoriteItemLabel: UILabel!
    @IBOutlet weak var mBalanceLabel: UILabel!
    
    @IBOutlet weak var mNameTextField: UITextField!
    @IBOutlet weak var mGenderTextfield: UITextField!
    @IBOutlet weak var mOldBirthdayStackView: UIStackView!
    @IBOutlet weak var mOldBirthdayLabel: UILabel!
    @IBOutlet weak var mMobileTextfield: UITextField!
    @IBOutlet weak var mEmailTextfield: UITextField!
    @IBOutlet weak var mFavoriteItemTextfield: UITextField!
    
    // 改之前
    private var nameText = ""
    private var genderText = ""
    private var birthdayYearText = ""
    private var birthdayMonthDayText = ""
    private var mobileText = ""
    private var emailText = ""
    private var favoriteText = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
        setMembershipData(membership: membershipDetail!)

        tabBarController?.tabBar.isHidden = true
        
        textFieldUnderlined()
        
        let customButton = UIButton(type: .custom)
        customButton.addTarget(self, action: #selector(saveChanged), for: .touchUpInside)
        customButton.setTitle("儲存", for: .normal)
        customButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customButton)
        
        yearTextField.inputView = pickerView
        monthDayTextField.inputView = pickerView
        
        yearTextField.delegate = self
        monthDayTextField.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func textFieldUnderlined() {
        mNameTextField.underlined()
        mGenderTextfield.underlined()
        yearTextField.underlined()
        monthDayTextField.underlined()
        mMobileTextfield.underlined()
        mEmailTextfield.underlined()
        mFavoriteItemTextfield.underlined()
    }

    func setMembershipData(membership:PFObject) {
        
        let memberDetail = transMembershipPFObjectToString(membership: membership)

        navigationItem.title = memberDetail[Membership.name]

        mNameTextField.text = memberDetail[Membership.name]

        mGenderTextfield.text = memberDetail[Membership.gender]

        let birthday: String = memberDetail[Membership.birthday] ?? ""
        mOldBirthdayLabel.text = "舊生日：" + birthday
        mOldBirthdayLabel.isHidden = birthday == ""
        mOldBirthdayStackView.isHidden = birthday == ""
        
        yearTextField.text = memberDetail[Membership.birthdayYear]
        monthDayTextField.text = memberDetail[Membership.birthdayMonthDay]
        
        mMobileTextfield.text = memberDetail[Membership.mobile]
        
        mEmailTextfield.text = memberDetail[Membership.email]
        
        mFavoriteItemTextfield.text = memberDetail[Membership.favoriteItem]
        
        mBalanceLabel.text = memberDetail[Membership.balance]?.components(separatedBy: ".")[0]
        
        queryExpensesRecord(membership: membership, queryLimit: RECORD_QUERY_LIMIT) { (objects) in
            
            for object in objects {
                self.expenses.append(self.transExpensesPFObjectToString(expensesRecord: object))
            }
            self.mTableView.reloadData()
        }

        if let text = mNameTextField.text {
            nameText = text
        }
        if let text = mGenderTextfield.text {
            genderText = text
        }
        if let text = yearTextField.text {
            birthdayYearText = text
        }
        if let text = monthDayTextField.text {
            birthdayMonthDayText = text
        }
        if let text = mEmailTextfield.text {
            emailText = text
        }
        if let text = mMobileTextfield.text {
            mobileText = text
        }
        if let text = mFavoriteItemTextfield.text {
            favoriteText = text
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! BankVC
        
        vc.name = (membershipDetail![Membership.name] as AnyObject).description
        
        vc.balance = (membershipDetail![Membership.balance] as AnyObject).description
        
        vc.memberId = membershipDetail!.objectId
        
        vc.delegate = self
    }
}

extension MembershipDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TransactionCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TransactionCell
        
        cell.timeLabel.text = expenses[indexPath.row][ExpensesRecord.updatedAt]
        
        if expenses[indexPath.row][ExpensesRecord.expend] == "0" {
            
            cell.payOrChargeLabel.text = "儲值："
            
            cell.payCoinLabel.text = expenses[indexPath.row][ExpensesRecord.deposits]
            
        } else {
            
            cell.payOrChargeLabel.text = "消費："
            
            cell.payCoinLabel.text = expenses[indexPath.row][ExpensesRecord.expend]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 {
            
            return true
            
        } else {
            
            return false
        }        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
            showAlertByTwoButton(title: "刪除?", message: nil, leftTitle: "先不要", leftStyle: .cancel, rightTitle: "刪除", rightStyle: .default) { _ in
                
            } rightAction: { _ in
                self.deleteRecord(indexPath: indexPath)
            }
            
            
        }
    }
    
    func deleteRecord(indexPath: IndexPath) {
        guard let recordId = expenses[indexPath.row][Membership.objectId] else {
            showMessage("資料錯誤", actions: nil)
            return
        }
        
        guard let expend = expenses[indexPath.row][ExpensesRecord.expend] else {
            showMessage("資料錯誤", actions: nil)
            return
        }
        
        guard let deposits = expenses[indexPath.row][ExpensesRecord.deposits] else {
            showMessage("資料錯誤", actions: nil)
            return
        }
        
        guard let membershipId = membershipDetail?.objectId else {
            showMessage("資料錯誤", actions: nil)
            return
        }
        
        guard let membershipName = membershipDetail?["name"] as? String else {
            showMessage("資料錯誤", actions: nil)
            return
        }
        
        var balance:Int = 0
        
        if expenses.count <= 1 {
            
            balance = 0
            
        } else {
            
            guard let balanceString = expenses[1][ExpensesRecord.balance] else {
                
                showMessage("資料錯誤", actions: nil)
                return
            }
            
            guard let balanceInt = Int(balanceString) else {
                
                showMessage("資料錯誤", actions: nil)
                return
            }
            
            balance = balanceInt
        }

        deleteExpensesRecord(membershipId: membershipId, memberName: membershipName, recordId: recordId, isDeleted: true, deposits: deposits, expend: expend, balance: balance) { (success, error) in
            
            if success {
                
                self.mBalanceLabel.text = "\(balance)"
                
                self.callback?(balance)
                
                self.recordDelegate?.deleteComplete(balance: balance)
                
                self.expenses.remove(at: indexPath.row)
                
                self.mTableView.reloadData()
                
            } else {
                self.showMessage("刪除失敗", actions: nil)
            }
        }
    }
}

extension MembershipDetailVC {
    @objc func saveChanged() {
        
        let ok = UIAlertAction(title: "OK", style: .default) { [self] (action) in
            
            guard let membership = self.membershipDetail else {
                self.showMessage("會員資料有誤", actions: nil)
                return
            }
            guard let membershipId = membership.objectId else {
                self.showMessage("會員資料有誤", actions: nil)
                return
            }
            
            let membershipClass = PFObject(withoutDataWithClassName: Membership.className, objectId: membershipId)

            if let text = self.mNameTextField.text {
                membershipClass[Membership.name] = text
                self.nameText = text
            }
            if let text = self.mGenderTextfield.text {
                membershipClass[Membership.gender] = text
                self.genderText = text
            }
            if let text = self.yearTextField.text {
                membershipClass[Membership.birthdayYear] = text
                self.birthdayYearText = text
            }
            if let text = self.monthDayTextField.text {
                membershipClass[Membership.birthdayMonthDay] = text
                self.birthdayMonthDayText = text
            }
            if let text = self.mEmailTextfield.text {
                membershipClass[Membership.email] = text
                self.emailText = text
            }
            if let text = self.mMobileTextfield.text {
                membershipClass[Membership.mobile] = text
                self.mobileText = text
            }
            if let text = self.mFavoriteItemTextfield.text {
                membershipClass[Membership.favoriteItem] = text
                self.favoriteText = text
            }
            
            self.newUpdate(membershipClass: membershipClass)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
            self.mNameTextField.text = self.nameText

            self.mGenderTextfield.text = self.genderText
            
            self.yearTextField.text = self.birthdayYearText
            self.monthDayTextField.text = self.birthdayMonthDayText

            self.mMobileTextfield.text = self.mobileText
            
            self.mEmailTextfield.text = self.emailText
            
            self.mFavoriteItemTextfield.text = self.favoriteText
        }
        
        view.endEditing(true)
        
        showMessage("確認修改", actions: [cancel, ok])
    }
}

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var payOrChargeLabel: UILabel!

    @IBOutlet weak var payCoinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension MembershipDetailVC: BankDelegate {
    
    func transactionComplete() {
        
        let memberId:String = membershipDetail!.objectId!
        
        queryMembershipDetail(memberId: memberId) { (object) in
            
            self.setMembershipData(membership: object)
            
            self.membershipDetail = object
        }
    }
}

extension MembershipDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerType {
        case .year:
            return 1
        case .monthDay:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerType {
        case .year:
            return years.count
            
        case .monthDay:
            switch component {
            case 0:
                return months.count
            case 1:
                return days[pickerView.selectedRow(inComponent: 0)].count
            default:
                return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerType {
        case .year:
            let taiwanYear = "\(Int(years[row])! - 1911)"
            return "西元" + years[row] + " = 民國" + taiwanYear + "年"
            
        case .monthDay:
            switch component {
            case 0:
                return months[row] + "月"
            case 1:
                return days[pickerView.selectedRow(inComponent: 0)][row] + "日"
            default:
                return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("didSelectRow", component)
        
        switch pickerType {
        case .year:
            yearTextField.text = years[row]
            
        case .monthDay:
            switch component {
            case 0:
                pickerView.reloadComponent(1)
            case 1:
                break
            default:
                break
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let month = self.months[pickerView.selectedRow(inComponent: 0)]
                let day = self.days[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)]
                self.monthDayTextField.text = "\(month)/\(day)"
            }
        }
    }
}

extension MembershipDetailVC {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == yearTextField {
            pickerType = .year
        }
        
        if textField == monthDayTextField {
            pickerType = .monthDay
        }
        
        pickerView.reloadAllComponents()
    }
}

