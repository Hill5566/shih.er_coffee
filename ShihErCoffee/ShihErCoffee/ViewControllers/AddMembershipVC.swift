//
//  AddNewMembershipVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/2/15.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

//new
class AddMembershipVC: CafeViewController {
    
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

    
    @IBOutlet weak var mobileCheckImageView: UIImageView!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var coinTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var monthDayTextField: UITextField!

//    @IBOutlet weak var postCodeTextField: UITextField!
    
    let mDatePicker = UIDatePicker()
    
//    @IBOutlet weak var coinLockerButton: UIButton!
    
//    @IBOutlet weak var postCodeLockerButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var favoriteItemTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
        setCafeTextField(nameTextField, placeHolderString: "姓名")
        setCafeTextField(mobileTextField, placeHolderString: "手機")
        setCafeTextField(coinTextField, placeHolderString: "幣")
        setCafeTextField(emailTextField, placeHolderString: "電子信箱")
        setCafeTextField(yearTextField, placeHolderString: "生日 - 年")
        setCafeTextField(monthDayTextField, placeHolderString: "生日 - 月日")
        setCafeTextField(favoriteItemTextField, placeHolderString: "備註")
        
        yearTextField.inputView = pickerView
        monthDayTextField.inputView = pickerView
        
        yearTextField.delegate = self
        monthDayTextField.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        setCafeButton(addButton)
    }
    
    @IBAction func mobileTextFieldEditingChanged(_ sender: UITextField) {
        
        if mobileValid(mobile: sender.text!) {
            
//            mobileCheckImageView.isHidden = false
            
        } else {
            
//            mobileCheckImageView.isHidden = true
        }
    }
    
    func mobileValid(mobile:String) -> Bool {
        
        var mobileText = mobile
        
        if mobileText == "" {
            return false
        }
        
        mobileText.removeFirst()
        
        mobileText = "+886" + mobileText
        
        if mobileText.isPhoneNumber {
            
            return true
            
        } else {
            
            return false
        }
    }
    
    @IBAction func coinTextFieldEditingDidBegin(_ sender: UITextField) {
        
        sender.text = ""
    }
    
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
    
    @IBAction func saveClick(_ sender: Any) {
        
        let nameText = self.nameTextField.text ?? ""
        
        let mobile = self.mobileTextField.text ?? ""
        
        guard let coinString = self.coinTextField.text else {return}
        
        let postCode = ""
        
        let name = nameText.trimmingCharacters(in: .whitespaces)
        
        if name == "" {
            
            self.showMessage("請輸入姓名", actions: nil)
            return
        }
        
        guard let coin:Int = Int(coinString) else {
            
            self.showMessage("幣輸入錯誤，請輸入數字", actions: nil)
            return
        }
        
        if coin < 0 {
            
            showMessage("幣輸入錯誤，請輸入正值", actions: nil)
            return
        }
        
        let year = yearTextField.text ?? ""
        
        let monthDay = monthDayTextField.text ?? ""
        
        let email = emailTextField.text ?? ""
        
        if mobileValid(mobile: mobile) {
            
            uploadNewMembership(mobile, name, postCode, coin, year, monthDay, email)
            
        } else {
            
            let messageAlert = UIAlertController(title: "\(mobile) 非電話，確定新增？", message: nil, preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "新增", style: .default, handler: { (alert) in
                
                self.uploadNewMembership(mobile, name, postCode, coin, year, monthDay, email)
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            messageAlert.addAction(okAction)
            messageAlert.addAction(cancelAction)
            
            self.present(messageAlert, animated: true, completion: nil)
        }
    }
    
    func uploadNewMembership(_ mobile: String, _ name: String, _ postCode: String, _ coin: Int, _ birthdayYear: String, _ birthdayMonthDay: String, _ email:String) {
      
        let alert = showLoading()
        
        checkExist(key: Membership.mobile, value: mobile) { (isExist, object) in
            
            if !isExist {
                
                self.findNewMembershipNumber { (object) in
                    
                    let number:Int = object
                    
                    self.addNewMembership(number: number,
                                          name: name,
                                          birthdayYear: birthdayYear,
                                          birthdayMonthDay: birthdayMonthDay,
                                          mobile: mobile,
                                          email: email,
                                          postCode: postCode,
                                          balance: coin,
                                          completion: { (success, error) in
                                            
                                            alert.dismiss(animated: false, completion: {
                                                
                                                if success {
                                                    
                                                    self.shouldUpdateMembership = true
                                                    
                                                    self.navigationController?.popViewController(animated: true)
                                                    
                                                } else {
                                                    
                                                    self.showMessage("add member error", actions: nil)
                                                }                                                
                                            })
                    })
                }
            } else {
                
                let mobileName:String = object![Membership.name] as! String
                
                alert.dismiss(animated: true, completion: {
                    
                    self.showMessage("\(mobile) \n此手機已被 \(mobileName) 登錄", actions: nil)
                })
            }
        }
    }
    
    func validate(value: String) -> Bool {
        
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let result =  phoneTest.evaluate(with: value)
        
        return result
    }
    
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
}

extension AddMembershipVC: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension AddMembershipVC {
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

