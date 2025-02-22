//
//  GoodsVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/11/12.
//  Copyright © 2018 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class GoodsVC: CafeViewController {

    @IBOutlet weak var hereTogoSwitchButton: UISwitch! {
        didSet {
            hereTogoSwitchButton.layer.cornerRadius = hereTogoSwitchButton.frame.height / 2
        }
    }
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var cartTableView: UITableView!
    
    var goods:[CoffieSubclassing] = []
    var group:[String] = []
    
    var shoppingCart:[SellList] = []
    
    @IBOutlet weak var checkButton: UIButton!
    
    @IBAction func check(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
    }
   
    @IBAction func switchHereTogo(_ sender: UISwitch) {
        
        shoppingCart = []
        
        mTableView.reloadData()
        cartTableView.reloadData()
        
        if sender.isOn {
            checkButton.backgroundColor = UIColor.here
        } else {
            checkButton.backgroundColor = UIColor.togo
        }
        
        checkButton.setTitle("結帳", for: .normal)
    }
    
    @IBAction func vip480ButtonClick(_ sender: UIButton) {
        
        guard let nickName = sender.titleLabel?.text else { return  }

        let selectedItems = goods.filter({$0.nickName == nickName})
  
        guard let selectedItem = selectedItems.first else { return }
        
        if hereTogoSwitchButton.isOn {
            if selectedItem.vipPriceHere480 != "" {
                addShoppingCartItem(selectedItem: selectedItem, is360cc: false, isHere: hereTogoSwitchButton.isOn)
            }
        } else {
            if selectedItem.vipPriceOut480 != "" {
                addShoppingCartItem(selectedItem: selectedItem, is360cc: false, isHere: hereTogoSwitchButton.isOn)
            }
        }
        cartTableView.reloadData()
    }
}

extension GoodsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView.tag == 0 {
            return group.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 0 {
            
            let cell:GoodsTableHeaderView = tableView.dequeueReusableCell(withIdentifier: "HeaderView") as! GoodsTableHeaderView
            
            cell.groupTitleLabel.text = group[section]
            
            if hereTogoSwitchButton.isOn {
                cell.contentView.backgroundColor = UIColor.here
            } else {
                cell.contentView.backgroundColor = UIColor.togo
            }
            return cell.contentView
            
        } else {
            
            let cell:ShoppingTableHeaderView = tableView.dequeueReusableCell(withIdentifier: "SellHeaderView") as! ShoppingTableHeaderView
            
            if hereTogoSwitchButton.isOn {
                cell.titleLabel.text = "內用"
                cell.contentView.backgroundColor = UIColor.here
            } else {
                cell.titleLabel.text = "外帶"
                cell.contentView.backgroundColor = UIColor.togo
            }
            return cell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 0 {
            
            let filtered = goods.filter({$0.group == group[section]})
            
            return filtered.count
            
        } else {
            return shoppingCart.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let cell:GoodsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! GoodsTableViewCell
            
            let filtered = goods.filter({$0.group == group[indexPath.section]})
            
            cell.textLabel?.text = filtered[indexPath.row].coffieName
            cell.nickNameLabel.text = filtered[indexPath.row].nickName
            
            if hereTogoSwitchButton.isOn {
                cell.vip360Label.text = filtered[indexPath.row].vipPriceHere360
                cell.vip480Label.text = filtered[indexPath.row].vipPriceHere480
            } else {
                cell.vip360Label.text = filtered[indexPath.row].vipPriceOut360
                cell.vip480Label.text = filtered[indexPath.row].vipPriceOut480
            }
            cell.vip480Button .setTitle(filtered[indexPath.row].nickName, for: .normal)
            return cell
            
        } else {
            
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SellCell")!
            cell.textLabel?.text = shoppingCart[indexPath.row].nickName + (" \(shoppingCart[indexPath.row].cc)cc")
            cell.detailTextLabel?.text = "\(shoppingCart[indexPath.row].count)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let filtered:[CoffieSubclassing] = goods.filter({$0.group == group[indexPath.section]})
        
        let selectedItem:CoffieSubclassing = filtered[indexPath.row]
        
        if tableView.tag == 0 {
            
            if hereTogoSwitchButton.isOn {
                if selectedItem.vipPriceHere360 != "" {
                    addShoppingCartItem(selectedItem: selectedItem, is360cc: true, isHere: hereTogoSwitchButton.isOn)
                } else if selectedItem.vipPriceHere480 != "" {
                    addShoppingCartItem(selectedItem: selectedItem, is360cc: false, isHere: hereTogoSwitchButton.isOn)
                }
            } else {
                if selectedItem.vipPriceOut360 != "" {
                    addShoppingCartItem(selectedItem: selectedItem, is360cc: true, isHere: hereTogoSwitchButton.isOn)
                } else if selectedItem.vipPriceOut480 != "" {
                    addShoppingCartItem(selectedItem: selectedItem, is360cc: false, isHere: hereTogoSwitchButton.isOn)
                }
            }
        } else {

            removeShoppingCartItemAt(row: indexPath.row)
        }
        cartTableView.reloadData()
        if shoppingCart.count == 0 {return}
        cartTableView.scrollToRow(at: IndexPath(row: shoppingCart.count-1, section: 0), at: .bottom, animated: true)
    }
    
    func addShoppingCartItem(selectedItem:CoffieSubclassing, is360cc:Bool, isHere:Bool) {
        
        let cc:String = is360cc ? "360" : "480"
        
        if shoppingCart.contains(where: {$0.nickName+" \($0.cc)" == selectedItem.nickName+" \(cc)"}) {
            
            for (index, sellItem ) in shoppingCart.enumerated() {
                
                if sellItem.nickName == selectedItem.nickName && sellItem.cc == cc {
                    
                    shoppingCart[index].count = shoppingCart[index].count + 1
                }
            }
        } else {
            
            if isHere {
                
                guard let priceHere360 = Int(selectedItem.vipPriceHere360) else {
                    
                    guard let priceHere480 = Int(selectedItem.vipPriceHere480) else { return }
                    
                    shoppingCart.append(SellList(nickName: selectedItem.nickName, cc:"480", price:priceHere480, count: 1))
                    updateBill()
                    return
                }
                let price:Int = is360cc ? priceHere360 : Int(selectedItem.vipPriceHere480)!
                shoppingCart.append(SellList(nickName: selectedItem.nickName, cc:cc, price:price, count: 1))
            } else {
                
                guard let priceTogo360 = Int(selectedItem.vipPriceOut360) else {
                    
                    guard let priceTogo480 = Int(selectedItem.vipPriceOut480) else { return }
                    
                    shoppingCart.append(SellList(nickName: selectedItem.nickName, cc:"480", price:priceTogo480, count: 1))
                    updateBill()
                    return
                }
                let price:Int = is360cc ? priceTogo360 : Int(selectedItem.vipPriceOut480)!
                shoppingCart.append(SellList(nickName: selectedItem.nickName, cc:cc, price:price, count: 1))
            }
        }
        updateBill()
    }
    
    func removeShoppingCartItemAt(row:Int) {
        
        if shoppingCart[row].count == 1 {
            
            shoppingCart.remove(at:row)
        } else {
            
            shoppingCart[row].count = shoppingCart[row].count - 1
        }
        updateBill()
    }
    
    func updateBill() {
        
        var bill:Int = 0
        
        for good in shoppingCart {
            bill = bill + good.price * good.count
        }
        
        checkButton.setTitle("結帳 \(bill)", for: .normal)
    }
}

class GoodsTableViewCell: UITableViewCell {
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var vip360Label: UILabel!
    @IBOutlet weak var vip480Label: UILabel!
    @IBOutlet weak var vip480Button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vip480Button.layer.borderColor = UIColor.cafeColor.cgColor
        vip480Button.layer.borderWidth = 1
    }
}

class GoodsTableHeaderView: UITableViewCell {
    @IBOutlet weak var groupTitleLabel: UILabel!
}

class ShoppingTableHeaderView: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
class ShoppingCartTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
}
class CoffieSubclassing : PFObject, PFSubclassing {
    
    @NSManaged var group: String
    @NSManaged var coffieName: String
    @NSManaged var nickName: String
    @NSManaged var vipPriceHere360: String
    @NSManaged var vipPriceHere480: String
    @NSManaged var vipPriceOut360: String
    @NSManaged var vipPriceOut480: String

    static func parseClassName() -> String {
        return "Coffie"
    }
}

struct SellList {
    let nickName:String
    let cc:String
    let price:Int
    var count:Int
}
