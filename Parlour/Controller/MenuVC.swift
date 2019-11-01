//
//  MenuVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-23.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 100
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
        setupView()
    }
    
    
    func setupView() {
        let order = uiRealm.objects(PersonalDB.self).filter("email == '\(AuthService.instance.userEmail)'")
        for item in order {
            let fiName = item.firstName
            let laName = item.lastName
            userNameLbl.text = "Welcome \(fiName) \(laName)!"
        }
    }
    
    
    
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
        let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let shopSelectVC = main.instantiateViewController(withIdentifier: "SWReveal") as! SWRevealViewController
        let reveal:SWRevealViewController = self.revealViewController()
        reveal.pushFrontViewController(shopSelectVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthService.instance.menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? MenuCell {
            let menu = AuthService.instance.menuList[indexPath.row]
            cell.cofigurationCell(menuDetails: menu)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let reveal:SWRevealViewController = self.revealViewController()
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell
        
        if cell.menuLbl.text! == "Book Now" {
            let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let shopSelectVC = main.instantiateViewController(withIdentifier: "SWReveal") as! SWRevealViewController
            reveal.pushFrontViewController(shopSelectVC, animated: true)
        }
//        if cell.menuLbl.text == "Logout" {
//            UserDataService.instance.logoutUser()
//            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
//            self.dismiss(animated: true, completion: nil)
//            let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let shopSelectVC = main.instantiateViewController(withIdentifier: "SWReveal") as! SWRevealViewController
//            reveal.pushFrontViewController(shopSelectVC, animated: true)
//        }
        if cell.menuLbl.text == "Profile" {
            let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = main.instantiateViewController(withIdentifier: "profileVC") as! UINavigationController
            reveal.pushFrontViewController(profileVC, animated: true)
        }
        if cell.menuLbl.text == "Appointments" {
            
            let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let reservationVC = main.instantiateViewController(withIdentifier: "reservationVc") as! UINavigationController
            reveal.pushFrontViewController(reservationVC, animated: true)
            
//            let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let reservationVC = main.instantiateViewController(withIdentifier: "reservationVc") as! ReservationVC
//            reveal.pushFrontViewController(reservationVC, animated: true)
        }
        if cell.menuLbl.text == "History" {
            let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let historyVC = main.instantiateViewController(withIdentifier: "historyVC") as! UINavigationController
            reveal.pushFrontViewController(historyVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }



}
