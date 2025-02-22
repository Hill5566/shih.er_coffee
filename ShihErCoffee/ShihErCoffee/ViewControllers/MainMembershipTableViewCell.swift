//
//  MainMembershipTableViewCell.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/2/17.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit

class MainMembershipTableViewCell: UITableViewCell {

    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var newBirthday: UILabel!
    @IBOutlet weak var birthday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
