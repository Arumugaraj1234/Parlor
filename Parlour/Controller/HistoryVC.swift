//
//  HistoryVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-28.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, RatingDelegate {
    
    //Outlets
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        tableView.delegate = self
        tableView.dataSource = self
        AuthService.instance.historyArray.removeAll()
        getHistoryDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let titleLabel = UILabel(frame: CGRect(x: (self.view.frame.width/2) - 50, y: 0, width: 100, height: 40))
        titleLabel.text = "HISTORY"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)
        navigationItem.titleView = titleLabel
    }
    
    func getHistoryDetails() {
        let order = uiRealm.objects(PersonalDB.self).filter("email == '\(AuthService.instance.userEmail)'")
        for item in order {
            userId = item.userId
        }
        AuthService.instance.getHistoryDetails(userId: userId, status: 2) { (success) in
            if success {
                if AuthService.instance.historyArray.count > 0 {
                    self.tableView.reloadData()
                } else {
                    let alert:UIAlertController = UIAlertController(title: "No History", message: "No Histories Found", preferredStyle: .alert)
                    let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert:UIAlertController = UIAlertController(title: "Oops!", message: "Something went wrong. Try again later.", preferredStyle: .alert)
                let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func styleBtnPressed(_ tag: Int, _ selectedIndex: Int) {
        let appointId = AuthService.instance.historyArray[selectedIndex].appointmentId
        print(appointId!)
        let givenRate = tag
        print(givenRate)
        AuthService.instance.giveRating(appointId: appointId!, rating: givenRate) { (success) in
            if success {
                let alert:UIAlertController = UIAlertController(title: "Thank You", message: "Rating has updated Successfully", preferredStyle: .alert)
                let done: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                { _ in
                    AuthService.instance.historyArray.removeAll()
                    self.getHistoryDetails()
                }
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert:UIAlertController = UIAlertController(title: "Oops!", message: "Something went wrong. Try again later.", preferredStyle: .alert)
                let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthService.instance.historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryCell {
            cell.ratingDelegate = self
            cell.tag = indexPath.row
            let history = AuthService.instance.historyArray[indexPath.row]
            cell.configureCell(history: history)
            return cell
        } else {
            return UITableViewCell()
        }
    }


}
