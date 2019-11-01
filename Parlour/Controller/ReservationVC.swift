//
//  ReservationVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-28.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class ReservationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ReservationCellDelegate {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    var userId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let revealController = self.revealViewController() {
            self.view.addGestureRecognizer(revealController.panGestureRecognizer())
            self.view.addGestureRecognizer(revealController.tapGestureRecognizer())
        }
        
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        tableView.delegate = self
        tableView.dataSource = self
        AuthService.instance.reservationArray.removeAll()
        getReservationDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let titleLabel = UILabel(frame: CGRect(x: (self.view.frame.width/2) - 50, y: 0, width: 100, height: 40))
        titleLabel.text = "APPOINTMENTS"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)
        navigationItem.titleView = titleLabel
    }
    
    func getReservationDetails() {
        let order = uiRealm.objects(PersonalDB.self).filter("email == '\(AuthService.instance.userEmail)'")
        for item in order {
            userId = item.userId
        }
        print(userId)
        AuthService.instance.getResevationDetails(userId: userId, status: 1) { (success) in
            if success {
                if AuthService.instance.reservationArray.count > 0 {
                    self.tableView.reloadData()
                } else {
                    let alert:UIAlertController = UIAlertController(title: "No Reservations", message: "No Reservations Found", preferredStyle: .alert)
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
    
    func didPressButton(_ tag: Int) {
        let alert = UIAlertController(title: "", message: "Are you sure to cancel the appointment?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { _ in
            self.shouldPresentLoadingViewWithText(true, "Cancelling...")
            let appointmentId = AuthService.instance.reservationArray[tag].appointmentId
            AuthService.instance.cancelAppointment(appointId: appointmentId!) { (success) in
                if success {
                    self.shouldPresentLoadingViewWithText(false, "")
                    let alert:UIAlertController = UIAlertController(title: "SUCCESS", message: "Successfully cancelled the appointment", preferredStyle: .alert)
                    let done: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                    { _ in
                        AuthService.instance.reservationArray.removeAll()
                        self.getReservationDetails()
                    }
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.shouldPresentLoadingViewWithText(false, "")
                    let alert:UIAlertController = UIAlertController(title: "Oops!", message: "Could not cancel the order right now", preferredStyle: .alert)
                    let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
        { _ in
            
            
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthService.instance.reservationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath) as? ReservationCell {
            cell.reservationDelegate = self
            cell.tag = indexPath.row
            let reservation = AuthService.instance.reservationArray[indexPath.row]
            cell.configureCell(reservation: reservation)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
