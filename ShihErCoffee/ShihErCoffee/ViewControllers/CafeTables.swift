//
//  CafeTables.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/2/8.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit

struct CafeTables {

}

enum HomeFunction: String {
    case stored = "儲值"
    case spend = "消費"
    case memberData = "會員資料"
}

struct AppSegue {
    
    static let storedVCToMembershipDetailVC = "StoredVCToMembershipDetailVC"
    
    static let spendVCToMembershipDetailVC = "SpendVCToMembershipDetailVC"

    static let membershipHomeVCToGoodsVC = "MembershipHomeVCToGoodsVC"

    static let membershipHomeVCToGoodsIPhoneVC = "MembershipHomeVCToGoodsIPhoneVC"

}


struct Membership {
    
    static let className = "Membership"
    static let number = "number"
    static let name = "name"
    static let gender = "gender"
    /// old deprecate
    static let birthday = "birthday"
    /// new
    static let birthdayYear = "birthdayYear"
    static let birthdayMonthDay = "birthdayMonthDay"
    static let mobile = "mobile"
    static let email = "email"
    static let favoriteItem = "favoriteItem"
    static let postCode = "postCode"
    static let balance = "balance"
    static let password = "password"
    static let isDeleted = "isDeleted"
    static let moneyBagPassword = "moneyBagPassword"
    static let specialGuest = "specialGuest"
    static let lastSpendTime = "lastSpendTime"
    static let lastStoredTime = "lastStoredTime"


    static let objectId = "objectId"
    static let updatedAt = "updateAt"
    static let createdAt = "createdAt"
    
}

enum MemberEditableField: Int {
    case Gender = 1
    case Birthday = 2
    case PhoneNumber = 3
    case Email = 4
    case FavoriteItem = 5
    case Name = 6
}

struct ExpensesRecord {
    
    static let className = "ExpensesRecord"

    static let name = "name"
    static let membershipId = "membershipId"
    static let expend = "expend"
    static let deposits = "deposits"
    static let balance = "balance"
    static let isDeleted = "isDeleted"

    static let objectId = "objectId"
    static let updatedAt = "updateAt"
    static let createdAt = "createdAt"
}

struct Sales {
    
    static let className = "Sales"
    static let transactionDate = "transactionDate"
    static let sellItem = "sellItem"
    static let qty = "qty"
    static let amount = "amount"
    static let memberNumber = "memberNumber"
    static let balance = "balance"
    static let merchant = "merchant"
    
    static let objectId = "objectId"
    static let updatedAt = "updateAt"
    static let createdAt = "createdAt"
}

struct AccountReceivable {
    
    static let className = "AccountReceivable"
    static let transactionDate = "transactionDate"
    static let orderDetail = "orderDetail"
    static let amount = "amount"
    static let paymentType = "paymentType"
    static let stuffID = "stuffID"
    
    static let objectId = "objectId"
    static let updatedAt = "updateAt"
    static let createdAt = "createdAt"
}

struct AccountPayable {
    
    static let className = "AccountPayable"
    static let transactionDate = "transactionDate"
    static let purchaseDetail = "purchaseDetail"
    static let amount = "amount"
    static let paymentType = "paymentType"
    static let stuffID = "stuffID"
    
    static let objectId = "objectId"
    static let updatedAt = "updateAt"
    static let createdAt = "createdAt"
}

struct Recharge {
    
    static let className = "Recharge"
    static let transactionDate = "transactionDate"
    static let membershipNumber = "membershipNumber"
    static let amount = "amount"
    static let paymentType = "paymentType"
    static let stuffID = "stuffID"
    
    static let objectId = "objectId"
    static let updatedAt = "updateAt"
    static let createdAt = "createdAt"
}

struct Coffie {
    static let className = "Coffie"
    let coffieName:String
}

struct Birthdate {
    var year:String?
}

struct MyUserDefault {

    let coinIsLocked = "coinIsLocked"
    let coinLockValue = "coinLockValue"
    let postCodeIsLocked = "postCodeIsLocked"
    let postCodeLockValue = "postCodeLockValue"

    init() {
        UserDefaults.standard.register(defaults: [coinIsLocked:true])
        UserDefaults.standard.register(defaults: [coinLockValue:"1000"])
        UserDefaults.standard.register(defaults: [postCodeIsLocked:false])
        UserDefaults.standard.register(defaults: [postCodeLockValue:""])
    }
}
