//
//  EditTopUpPlansVC.swift
//  CafeCoin
//
//  Created by Hill Lin on 2020/9/29.
//  Copyright © 2020 Lin Hill. All rights reserved.
//

import UIKit

class EditTopUpPlansVC: CafeViewController {

    public var plans:[String] = []
    public var changedPlansCallback:(()->())?

    @IBAction func close(_ sender: UIButton) {
        changedPlansCallback?()
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var addTextField: UITextField!
    
    @IBAction func addTextFieldEditingChanged(_ sender: UITextField) {
        
    }
    
    @IBAction func add(_ sender: UIButton) {
        guard let text = addTextField.text else { return }
        plans.append(text)
        UserSetting.default.saveStoredPlans(plans: plans)
        mTableView.reloadData()
        addTextField.text = ""
    }
    
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        print(plans)
    }
    
    
    @IBAction func deleteCellClick(_ sender: UIButton) {
        plans.remove(at: sender.tag)
        UserSetting.default.saveStoredPlans(plans: plans)
        mTableView.reloadData()
    }
    
}

extension EditTopUpPlansVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TopUpPlansCell
        
        cell.mLabel.text = plans[indexPath.row]
        cell.mDeleteButton.tag = indexPath.row
        
        return cell
    }
}

class TopUpPlansCell: UITableViewCell {
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var mDeleteButton: UIButton!
}
