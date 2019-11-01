//
//  StylistSelectVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-20.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class StylistSelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    //Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedShopId:Int?
    var selectedStylistid: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        AuthService.instance.stylists.removeAll()
        getStylists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let titleLabel = UILabel(frame: CGRect(x: (self.view.frame.width/2) - 50, y: 0, width: 100, height: 40))
        titleLabel.text = "STYLISTS"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)
        navigationItem.titleView = titleLabel
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        AuthService.instance.stylists.removeAll()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func getStylists() {
        if selectedShopId != nil {
            AuthService.instance.getStylistDetails(parlorId: selectedShopId!, completion: { (success) in
                if success {
                    self.tableView.reloadData()
                } else {
                    let alert:UIAlertController = UIAlertController(title: "Oops!", message: "Unable to Load Stylist. Try again later", preferredStyle: .alert)
                    let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthService.instance.stylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "stylishDetailsCell", for: indexPath) as? StylishDetailsCell {
            let stylist = AuthService.instance.stylists[indexPath.row]
            cell.configureCell(stylist: stylist)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStylist = AuthService.instance.stylists[indexPath.row]
        AuthService.instance.selectedStylist = selectedStylist
        self.selectedStylistid = selectedStylist.stylistId
        performSegue(withIdentifier: TO_TIME_STYLE_VC, sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let styleVC = segue.destination as? TimeAndStyleSelectVC {
            styleVC.selectedStylistid = self.selectedStylistid
        }
    }
    
    
}
