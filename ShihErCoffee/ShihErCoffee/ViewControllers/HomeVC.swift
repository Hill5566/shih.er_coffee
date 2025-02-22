//
//  HomeVC.swift
//  CafeCoin
//
//  Created by Lin Hill on 2018/5/30.
//  Copyright © 2018年 Lin Hill. All rights reserved.
//

import UIKit
import Parse

class HomeVC: CafeViewController {

    private var collectionItems = ["儲值", "消費", "會員資料", "加入會員"]
    private var goods:[CoffieSubclassing] = []
    
    @IBOutlet weak var buildNumberLabel: UILabel!
    
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var logView: UIView!
    
    
    @objc func transactionRecord() {
        let vc = UIStoryboard(name: "Boss", bundle: nil).instantiateViewController(withIdentifier: "TransactionRecordVC") as! TransactionRecordVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logRecord() {
        let vc = UIStoryboard(name: "Boss", bundle: nil).instantiateViewController(withIdentifier: "SystemLogVC") as! SystemLogVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC", self)
        
        let transactionButton = UIButton(type: .custom)
        transactionButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        transactionView.addSubview(transactionButton)
        
        let transactionDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(transactionRecord))
        transactionDoubleTapGesture.numberOfTapsRequired = 2
        transactionButton.addGestureRecognizer(transactionDoubleTapGesture)
            
        
        
        let logButton = UIButton(type: .custom)
        logButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        logView.addSubview(logButton)
        
        let logDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(logRecord))
        logDoubleTapGesture.numberOfTapsRequired = 2
        logButton.addGestureRecognizer(logDoubleTapGesture)
        
        versionInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if PFUser.current() == nil {
            
            UIManager.switchToBossLogin()
        
        } else {
            
        }
    }

    @IBAction func logoutClick(_ sender: UIButton) {
        showAlertByTwoButton(title: "登出?", message: nil, leftTitle: "先不要", leftStyle: .cancel, rightTitle: "登出", rightStyle: .default) { _ in
            
        } rightAction: { _ in
            PFUser.logOut()
            UIManager.switchToBossLogin()
        }
    }
}

extension HomeVC {
    func versionInfo() {
        let version:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let build:String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        buildNumberLabel.text = version + "." + build
    }
    func checkIsIphoneIpad() {
        
        var group:[String] = []
        for good in goods {
            if !group.contains(good.group) {
                group.append(good.group)
            }
        }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            let vc = storyboard!.instantiateViewController(withIdentifier: "GoodsIPhoneVC") as! GoodsIPhoneVC
            vc.goods = goods
            vc.group = group
            navigationController?.pushViewController(vc, animated: true)
        case .pad:
            let vc = storyboard!.instantiateViewController(withIdentifier: "GoodsVC") as! GoodsVC
            vc.goods = goods
            vc.group = group
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("other")
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionCell
        let item = collectionItems[indexPath.item]
        cell.mImageView.image = UIImage(named: item)
        cell.mLabel.text = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let membershipVC = UIStoryboard(name: "Transaction", bundle: nil).instantiateViewController(withIdentifier: "MembershipVC") as! MembershipVC

        switch indexPath.item {
        case 0:
            membershipVC.fromWhichFunction = .stored
            navigationController?.pushViewController(membershipVC, animated: true)
        case 1:
            membershipVC.fromWhichFunction = .spend
            navigationController?.pushViewController(membershipVC, animated: true)
        case 2:
            membershipVC.fromWhichFunction = .memberData
            navigationController?.pushViewController(membershipVC, animated: true)
        case 3:
            let vc = storyboard!.instantiateViewController(withIdentifier: "AddMembershipVC") as! AddMembershipVC
            navigationController?.pushViewController(vc, animated: true)
//        case 4:
//            
//            if goods != [] {
//                checkIsIphoneIpad()
//                return
//            }
//
//            queryGoods { (objects, error) in
//                if objects == [] {
//                    print("無商品, 需新增")
//                    return
//                }
//                if error != nil {
//                    self.showMessage("網路異常", actions: nil)
//                    return
//                }
//                
//                for object in objects {
//                    if let good = object as? CoffieSubclassing {
//                        self.goods.append(good)
//                    }
//                }
//                self.checkIsIphoneIpad()
//            }
        default:
            print(collectionItems[indexPath.item])
        }
    }
    
}

class HomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mImageView: UIImageView!
    
    @IBOutlet weak var mLabel: UILabel!
    
}
