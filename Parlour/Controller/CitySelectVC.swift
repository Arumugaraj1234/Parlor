//
//  CitySelectVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-02.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class CitySelectVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    
    //Outlets
    @IBOutlet weak var cityNameTxt: UITextField!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var cityNamesTV: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var citiesToShowInTV = ["Chennai", "Trichy", "Madurai", "Nellai", "Kovai", "Tenkasi"]
    var citiesList: [String] = Array()
    var isCityNameMatched: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        cityNamesTV.delegate = self
        cityNamesTV.dataSource = self
        cityNameTxt.delegate = self
        cityNameTxt.tag = 0
        for city in citiesToShowInTV {
            citiesList.append(city)
        }
    }
    
    func setupView() {
        cityNameTxt.layer.cornerRadius = 20.0
        cityNameTxt.layer.borderWidth = 2.0
        goBtn.layer.cornerRadius = 20.0
        goBtn.isEnabled = false
    }
    
    @objc func searchCitiesName(_ textField: UITextField) {
        self.citiesToShowInTV.removeAll()
        if textField.text?.count != 0 {
            for city in citiesList {
                let range = city.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    citiesToShowInTV.append(city)
                }
            }
            if citiesToShowInTV.count <= 3 {
                tableViewHeight.constant = CGFloat(citiesToShowInTV.count * 40)
            } else {
                tableViewHeight.constant = 120
            }
        } else {
            for city in citiesList {
                citiesToShowInTV.append(city)
            }
        }
        cityNamesTV.reloadData()
    }

    @IBAction func goBtnPressed(_ sender: Any) {
        checkCriteria()
        if isCityNameMatched == true {
             self.performSegue(withIdentifier: TO_SHOP_SELECT_VC, sender: nil)
        } else {
            let alert:UIAlertController = UIAlertController(title: "Alert!", message: "Entered City is Not valid", preferredStyle: .alert)
            let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkCriteria() {
        if cityNameTxt.text != "" {
            for var i in (0..<citiesList.count) {
                if cityNameTxt.text == citiesList[i] {
                    isCityNameMatched = true
                    break
                } else {
                    isCityNameMatched = false
                }
            }
        }
    }

    //TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesToShowInTV.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.cityNamesTV.dequeueReusableCell(withIdentifier: "cityNameCell", for: indexPath) as? CityNameCell {
            cell.cityNameLbl.text = citiesToShowInTV[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityNameTxt.text = citiesToShowInTV[indexPath.row]
        cityNamesTV.isHidden = true
        cityNameTxt.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        citiesToShowInTV = ["Chennai", "Trichy", "Madurai", "Nellai", "Kovai", "Tenkasi"]
        tableViewHeight.constant = 120
        cityNamesTV.reloadData()
        cityNamesTV.isHidden = false
        if textField.tag == 0 {
            textField.text = ""
            textField.addTarget(self, action: #selector(searchCitiesName(_:)), for: .editingChanged)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityNameTxt.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            if textField.text != "" {
                cityNamesTV.isHidden = true
                goBtn.isEnabled = true
            } else {
                goBtn.isEnabled = false
            }
        }
    }
    
   
}
