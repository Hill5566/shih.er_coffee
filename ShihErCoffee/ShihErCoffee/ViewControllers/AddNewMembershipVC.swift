////
////  AddNewMembershipVC.swift
////  CafeCoin
////
////  Created by Lin Hill on 2018/2/15.
////  Copyright © 2018年 Lin Hill. All rights reserved.
////
//
//import UIKit
//import Parse
//
////Old
//class AddNewMembershipVC: CafeViewController {
//
//    @IBOutlet weak var mobileCheckImageView: UIImageView!
//
//    @IBOutlet weak var mobileTextField: UITextField!
//
//    var birthday:String = ""
//
//    @IBOutlet weak var coinTextField: UITextField!
//
//    @IBOutlet weak var nameTextField: UITextField!
//
//    @IBOutlet weak var birthdayTextField: UITextField!
//
//    @IBOutlet weak var postCodeTextField: UITextField!
//
//    let mDatePicker = UIDatePicker()
//
//    @IBOutlet weak var coinLockerButton: UIButton!
//
//    @IBOutlet weak var postCodeLockerButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setUserDefault()
//
//        setDatePicker()
//
//        self.tabBarController?.tabBar.isHidden = true
//    }
//
//    func setUserDefault() {
//
//        if mUser.bool(forKey: myUserDefault.coinIsLocked) {
//
//            coinTextField.text = mUser.string(forKey: myUserDefault.coinLockValue)
//
//            coinLockerButton.setBackgroundImage(UIImage.init(named: "icons8-privacy"), for: .normal)
//
//        } else {
//
//            coinTextField.text = ""
//
//            coinLockerButton.setBackgroundImage(UIImage.init(named: "icons8-unlock"), for: .normal)
//
//        }
//
//        if mUser.bool(forKey: myUserDefault.postCodeIsLocked) {
//
//            postCodeTextField.text = mUser.string(forKey: myUserDefault.postCodeLockValue)
//
//            postCodeLockerButton.setBackgroundImage(UIImage.init(named: "icons8-privacy"), for: .normal)
//
//        } else {
//
//            postCodeTextField.text = ""
//
//            postCodeLockerButton.setBackgroundImage(UIImage.init(named: "icons8-unlock"), for: .normal)
//        }
//    }
//
//    @IBAction func coinLockerClick(_ sender: UIButton) {
//
//        let coinIsLocked = mUser.bool(forKey: myUserDefault.coinIsLocked)
//
//        let coin:String = coinTextField.text!
//
//        if coinIsLocked {
//
//            mUser.set("", forKey: myUserDefault.coinLockValue)
//
//            coinLockerButton.setBackgroundImage(UIImage.init(named: "icons8-unlock"), for: .normal)
//
//        } else {
//            print(coin)
//            mUser.set(coin, forKey: myUserDefault.coinLockValue)
//
//            coinLockerButton.setBackgroundImage(UIImage.init(named: "icons8-privacy"), for: .normal)
//        }
//
//        mUser.set(!coinIsLocked, forKey: myUserDefault.coinIsLocked)
//    }
//
//    @IBAction func postCodeLockerClick(_ sender: UIButton) {
//
//        let postCodeIsLocked = mUser.bool(forKey: myUserDefault.postCodeIsLocked)
//
//        let postCode:String = postCodeTextField.text!
//
//        if postCodeIsLocked {
//
//            mUser.set("", forKey: myUserDefault.postCodeLockValue)
//
//            postCodeLockerButton.setBackgroundImage(UIImage.init(named: "icons8-unlock"), for: .normal)
//
//        } else {
//
//            mUser.set(postCode, forKey: myUserDefault.postCodeLockValue)
//
//            postCodeLockerButton.setBackgroundImage(UIImage.init(named: "icons8-privacy"), for: .normal)
//        }
//
//        mUser.set(!postCodeIsLocked, forKey: myUserDefault.postCodeIsLocked)
//    }
//
//    @IBAction func mobileTextFieldEditingChanged(_ sender: UITextField) {
//
//        if mobileValid(mobile: sender.text!) {
//
//            mobileCheckImageView.isHidden = false
//
//        } else {
//
//            mobileCheckImageView.isHidden = true
//        }
//    }
//
//    func mobileValid(mobile:String) -> Bool {
//
//        var mobileText = mobile
//
//        if mobileText == "" {
//            return false
//        }
//
//        mobileText.removeFirst()
//
//        mobileText = "+886" + mobileText
//
//        if mobileText.isPhoneNumber {
//
//            return true
//
//        } else {
//
//            return false
//        }
//    }
//
//    @IBAction func coinTextFieldEditingDidBegin(_ sender: UITextField) {
//
//        sender.text = ""
//    }
//
//    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
//
//        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
//
//        if let day = componenets.day, let month = componenets.month {
//
//            var dayString = "\(day)"
//
//            var monthString = "\(month)"
//
//            if day < 10 {
//
//                dayString = "0\(day)"
//            }
//
//            if month < 10 {
//
//                monthString = "0\(month)"
//            }
//
//            birthday = monthString + dayString
//
//            self.birthdayTextField.text = "\(month) / \(day)"
//
//        }
//    }
//
//    @IBAction func saveClick(_ sender: Any) {
//
//        let mobile = self.mobileTextField.text!
//
//        let name = self.nameTextField.text!
//
//        let postCode = self.postCodeTextField.text!
//
//        guard let coin:Double = Double(self.coinTextField.text!) else {
//
//            self.showMessage("coin invalid value", action: nil)
//
//            return
//        }
//
//        if coin < 0 {
//
//            showMessage("coin invalid value", action: nil)
//
//            return
//        }
//
//        if mobileValid(mobile: mobile) {
//
//            uploadNewMembership(mobile, name, postCode, coin)
//
//        } else {
//
//            let messageAlert = UIAlertController(title: "\(mobile) 非電話", message: nil, preferredStyle: UIAlertControllerStyle.alert)
//
//            let okAction = UIAlertAction(title: "Continue", style: .default, handler: { (alert) in
//
//                self.uploadNewMembership(mobile, name, postCode, coin)
//            })
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//            messageAlert.addAction(okAction)
//            messageAlert.addAction(cancelAction)
//
//            self.present(messageAlert, animated: true, completion: nil)
//        }
//    }
//
//    func uploadNewMembership(_ mobile: String, _ name: String, _ postCode: String, _ coin: Double) {
//        checkExist(key: Membership.mobile, value: mobile) { (isExist, object) in
//
//            if !isExist {
//
//                self.findNewMembershipNumber { (object) in
//
//                    let number:Int = object
//
//                    self.addNewMembership(number: number,
//                                          name: name,
//                                          birthday: self.birthday,
//                                          mobile: mobile,
//                                          postCode: postCode,
//                                          balance: coin,
//                                          completion: { (success, error) in
//
//                                            if success {
//
//                                                self.shouldUpdateMembership = true
//
//                                                self.navigationController?.popViewController(animated: true)
//
//                                            } else {
//
//                                                self.showMessage("add member error", action: nil)
//                                            }
//                    })
//                }
//
//            } else {
//
//                let mobileName:String = object![Membership.name] as! String
//
//                self.showMessage("\(mobile) 已有人使用\n登錄名：\(mobileName)", action: nil)
//            }
//        }
//    }
//
//    func validate(value: String) -> Bool {
//
//        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
//
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
//
//        let result =  phoneTest.evaluate(with: value)
//
//        return result
//    }
//
//    func setDatePicker() {
//
//        mDatePicker.datePickerMode = UIDatePickerMode.date
//
//        mDatePicker.locale = Locale.init(identifier: "zh_tw")
//
//        mDatePicker.date = Date(timeIntervalSince1970: 960998400)
//
//        mDatePicker.minimumDate = Date(timeIntervalSince1970: 946656000)
//
//        mDatePicker.maximumDate = Date(timeIntervalSince1970: 978192000)
//
//        mDatePicker.backgroundColor = UIColor.white
//
//        mDatePicker.setValue(UIColor.cafeColor, forKeyPath: "textColor")
//
//        mDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
//
//        birthdayTextField.inputView = mDatePicker
//    }
//}
//
//
//
