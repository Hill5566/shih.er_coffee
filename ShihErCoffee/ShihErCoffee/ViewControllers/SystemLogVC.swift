//
//  SystemLogVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/12/12.
//  Copyright © 2018 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class SystemLogVC: CafeViewController {

    var skipRecord = 0
    
    @IBOutlet weak var skipTextField: UITextField!
    
    let pickerView = UIPickerView()
    let pickerViewContent = [0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    
    let updateAtDateFormatter:DateFormatter = DateFormatter()
    
    var records:[SystemLogSubclassing] = []
    
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
        
        querySystemLog { (objects) in
            for object in objects {
                if let record = object as? SystemLogSubclassing {
                    self.records.append(record)
                }
            }
            self.mTableView.reloadData()
        }
    }
    
    func querySystemLog(complete: @escaping ([PFObject]) -> ()) {
        
        let querySystemLog = PFQuery(className: SystemLogSubclassing.parseClassName())
        
        querySystemLog.order(byDescending: "updatedAt")
        
        querySystemLog.skip = skipRecord
        
        querySystemLog.findObjectsInBackground { (objects, error) in
            
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

extension SystemLogVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let record = records[indexPath.row]
       
        cell.textLabel?.text = translatorLog(log: record.log)
        
        if let updatedAt = record.updatedAt {
            cell.detailTextLabel?.text = updateAtDateFormatter.string(from: updatedAt)
        } else {
            cell.detailTextLabel?.text = "unknow"
        }        
        
        return cell
    }
    
    func translatorLog(log:String) -> String {
        
        let addMembership = "AddMembership"
        let addExpensesRecord = "AddExpensesRecord"
        let deleteExpensesRecord = "DeleteExpensesRecord"
        let deleteMembership = "DeleteMembership"
        let depostis = "deposits"
        let expend = "expend"
        
        return log.replacingOccurrences(of: addMembership, with: "新增會員")
            .replacingOccurrences(of: addExpensesRecord, with: "新增交易")
            .replacingOccurrences(of: deleteExpensesRecord, with: "刪除交易")
            .replacingOccurrences(of: deleteMembership, with: "刪除會員")
            .replacingOccurrences(of: depostis, with: "儲值")
            .replacingOccurrences(of: expend, with: "消費")
    }
}

extension SystemLogVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
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

class SystemLogSubclassing : PFObject, PFSubclassing {
    
    @NSManaged var log: String
    
    static func parseClassName() -> String {
        return "SystemLog"
    }
}
