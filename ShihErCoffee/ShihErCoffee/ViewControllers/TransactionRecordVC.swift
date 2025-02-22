//
//  TransactionRecordVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/12/3.
//  Copyright © 2018 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class TransactionRecordVC: CafeViewController {

    var skipRecord = 0
    
    @IBOutlet weak var skipTextField: UITextField!
    
    let pickerView = UIPickerView()
    let pickerViewContent = [0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    
    let updateAtDateFormatter:DateFormatter = DateFormatter()
    
    var records:[ExpensesRecordSubclassing] = []
    
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
        pickerView.delegate = self
        
        skipTextField.inputView = pickerView
        
        updateAtDateFormatter.dateFormat = "HH:mm MM/dd yyyy"
        
        queryRecordResult()
    }
    
    func queryRecordResult() {
        
        records = []
        
        queryExpensesRecord { (objects) in
            for object in objects {
                if let record = object as? ExpensesRecordSubclassing {
                    self.records.append(record)
                }
            }
            self.mTableView.reloadData()
        }
    }
    
    func queryExpensesRecord(complete: @escaping ([PFObject]) -> ()) {
        
        let queryMembership = PFQuery(className: ExpensesRecord.className)

        queryMembership.order(byDescending: "updatedAt")
        
        queryMembership.skip = skipRecord
        
        queryMembership.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                guard let objects = objects else { return }
                
                complete(objects)
                
            } else {
                
                self.showMessage("queryExpensesRecord error", actions: nil)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mTableView.isScrollEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mTableView.isScrollEnabled = true
    }
}

extension TransactionRecordVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        
        return cell?.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ExpensesRecordCell
        
        let record = records[indexPath.row]
        cell.nameLabel.text = record.name
        cell.expendLabel.text = "\(record.expend)"
        cell.depositsLabel.text = "\(record.deposits)"
        cell.balanceLabel.text = "\(record.balance)"
        
        if let updatedAt = record.updatedAt {
            cell.updateAtLabel.text = updateAtDateFormatter.string(from: updatedAt)
        } else {
            cell.updateAtLabel.text = "unknow"
        }
        
        if record.isDeleted {
            cell.backgroundColor = UIColor.yellow
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
}

extension TransactionRecordVC: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewContent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerViewContent[row]+1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        skipTextField.text = "\(pickerViewContent[row]+1)"
        skipTextField.endEditing(true)
        skipRecord = pickerViewContent[row]
        queryRecordResult()
    }
}

class ExpensesRecordSubclassing : PFObject, PFSubclassing {
    
    @NSManaged var balance: Int
    @NSManaged var deposits: Int
    @NSManaged var expend: Int
    @NSManaged var name: String
    @NSManaged var isDeleted: Bool
    
    static func parseClassName() -> String {
        return "ExpensesRecord"
    }
}

struct ExpensesRecordInfo {
    
    let balance:Int
    let deposits:Int
    let expend:Int
    let name:String
    let isDeleted:Bool
    let updateAt:Date
    
    init(_ dictionary:PFObject) {

        self.balance = dictionary[ExpensesRecord.balance] as? Int ?? 0
        self.deposits = dictionary[ExpensesRecord.deposits] as? Int ?? 0
        self.expend = dictionary[ExpensesRecord.expend] as? Int ?? 0
        self.name = dictionary[ExpensesRecord.name] as? String ?? ""
        self.isDeleted = dictionary[ExpensesRecord.isDeleted] as? Bool ?? false
        self.updateAt = dictionary.updatedAt ?? Date()
    }
    
}

class ExpensesRecordCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expendLabel: UILabel!
    @IBOutlet weak var depositsLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var updateAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
