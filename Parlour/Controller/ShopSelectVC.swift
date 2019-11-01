//
//  ShopSelectVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-02.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit
import RevealingSplashView

class ShopSelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    @IBOutlet weak var loginBtn: UIBarButtonItem!
    
    var shopName = ""
    var shopAddress = ""
    var shopLocation = ""
    var selectedShopId:Int?
    let appleImage = UIImage(named: "apple")
    let revealSplashView = RevealingSplashView(iconImage: UIImage(named:"apple")!, iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: UIColor.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deviceId = 	UIDevice.current.identifierForVendor?.uuidString
        print(deviceId)
        self.view.addSubview(revealSplashView)
        revealSplashView.animationType = SplashAnimationType.squeezeAndZoomOut
        revealSplashView.startAnimation()
        tableView.delegate = self
        tableView.dataSource = self
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        AuthService.instance.getTimeSettings { (success) in
            if success {
                AuthService.instance.timePeriodList = AuthService.instance.fixedTimeList
                AuthService.instance.truncateTimePeriodAtBegin(startTime: AuthService.instance.startTime)
                AuthService.instance.truncateTimePeriodAtEnd(endTime: AuthService.instance.endTime)
                
                
            } else {
                print("Something wrong in getting time settings")
            }
        }
        loginBtn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 14)!], for: .normal)
        navigationItem.rightBarButtonItem = loginBtn
        navigationItem.leftBarButtonItem = menuBtn
        NotificationCenter.default.addObserver(self, selector: #selector(ShopSelectVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        if AuthService.instance.isLoggedIn {
            menuBtn.isEnabled = true
            menuBtn.tintColor = UIColor.black
            loginBtn.isEnabled = false
            loginBtn.tintColor = UIColor.clear
        } else {
            menuBtn.isEnabled = false
            menuBtn.tintColor = UIColor.clear
            loginBtn.isEnabled = true
            loginBtn.tintColor = UIColor.white
        }
        AuthService.instance.shops.removeAll()
        getShopDetails()
        revealSplashView.heartAttack = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //let topBarHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let titleLabel = UILabel(frame: CGRect(x: (self.view.frame.width/2) - 50, y: 0, width: 100, height: 40))
        titleLabel.text = "PARLORS"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)
        navigationItem.titleView = titleLabel
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN_VC, sender: self)
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn {
            menuBtn.isEnabled = true
            menuBtn.tintColor = UIColor.black
            loginBtn.isEnabled = false
            loginBtn.tintColor = UIColor.clear
        } else {
            menuBtn.isEnabled = false
            menuBtn.tintColor = UIColor.clear
            loginBtn.isEnabled = true
            loginBtn.tintColor = UIColor.white
        }
    }
    
    func getShopDetails() {
        AuthService.instance.getShopDetails { (success) in
            if success {
                self.tableView.reloadData()
            } else {
                let alert:UIAlertController = UIAlertController(title: "Oops!", message: "Unable to Load Shops. Try again later", preferredStyle: .alert)
                let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthService.instance.shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "shopDetailsCell", for: indexPath) as? ShopDetailsCell {
            let shops = AuthService.instance.shops[indexPath.row]
            cell.configureCell(shopDetails: shops)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let shop = AuthService.instance.shops[indexPath.row]
        AuthService.instance.selectedShop = shop
        self.selectedShopId = shop.id
        AuthService.instance.selectedParlorId = shop.id
        performSegue(withIdentifier: TO_STYLISH_SELECT_VC, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_STYLISH_SELECT_VC {
            let stylishSelectVc = segue.destination as! StylistSelectVC
            stylishSelectVc.selectedShopId = self.selectedShopId
        }

    }
    
    
}
