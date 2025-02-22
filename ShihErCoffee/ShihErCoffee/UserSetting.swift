//
//  UserSetting.swift
//  CafeCoin
//
//  Created by Hill Lin on 2020/9/29.
//  Copyright © 2020 Lin Hill. All rights reserved.
//

import UIKit

class UserSetting {
    static let `default` = UserSetting()

    //一次存多少錢,用”,“分開 是個array
    var storedPlansString :String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "storedPlans")
        }
        get {
            guard let t = UserDefaults.standard.string(forKey: "storedPlans") else {
                return nil
            }
            return t
        }
    }
    func saveStoredPlans(plans:[String]) {
        if plans == [] {
            storedPlansString = nil
            return
        }
        var plansString = ""
        for p in plans {
            plansString = plansString + p + ","
        }
        plansString.removeLast()
        storedPlansString = plansString
    }
    func loadStoredPlans() -> [String]? {
        print("loadStoredPlans", storedPlansString, storedPlansString?.components(separatedBy: ","))
        return storedPlansString?.components(separatedBy: ",")
    }
}
