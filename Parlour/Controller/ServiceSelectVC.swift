//
//  ServiceSelectVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-02.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class ServiceSelectVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var shopNameLbl: UILabel!
    @IBOutlet weak var shopLocationlbl: UILabel!
    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var totalChargesLbl: UILabel!
    
    //Variables
    var shopName = ""
    var shopAddress = ""
    var shopLocation = ""
    let index = IndexPath(row: 0, section: 0)
    let index1 = IndexPath(row: 1, section: 0)
    let index2 = IndexPath(row: 2, section: 0)
    let index3 = IndexPath(row: 3, section: 0)
    let index4 = IndexPath(row: 4, section: 0)
    let index5 = IndexPath(row: 5, section: 0)
    let tickedBox:UIImage = UIImage(named: "tick_box")!
    let untickedBox:UIImage = UIImage(named: "un_tick_box")!
    var tempTotal = 0
    
    var totalhairCutCharges = 0
    var totalMassageCharges = 0
    var totalFacialCharges = 0
    var grandTotal = 0
    
    //HaircutServices Selected State Indicators
    var isServicesTypeOneBtnSelected: Bool = false
    var isServiceASelected: Bool = false
    var isServiceBSelected: Bool = false
    var isServiceCSelected: Bool = false
    var haircutTotal = 0
    
    //Massage Services Selected State Indicators
    
    var isMassageServiceSelected: Bool = false
    var isMassageTypeASelected: Bool = false
    var isMassageTypeBSelected: Bool = false
    var isMassageTypeCSelected: Bool = false
    var massageServiceTotal = 0
    
    //Facial Services Selected State Indicators
    
    var isFacialServiceSelected: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        shopNameLbl.text = shopName
        shopLocationlbl.text = shopLocation
        totalChargesLbl.text = " $0"
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func servicesTypeOneBtnPressed(_ sender: Any) {
        if let cell = self.serviceTableView.cellForRow(at: index) as? ServicesTypeOneCell {
            if isServicesTypeOneBtnSelected == true {
                cell.headServiceBtn.setImage(untickedBox, for: .normal)
                if let cell1 = self.serviceTableView.cellForRow(at: index1) as? TypeOneServicesDetailsCell {
                    cell1.serviceTypeABtn.setImage(untickedBox, for: .normal)
                    cell1.servicesTypeBBtn.setImage(untickedBox, for: .normal)
                    cell1.servicesTypeCBtn.setImage(untickedBox, for: .normal)
                    isServiceASelected = false
                    isServiceBSelected = false
                    isServiceCSelected = false
                    haircutTotal = 0
                    totalhairCutCharges = estimatedCharges(serviceA: 0, serviceB: 0, serviceC: 0)
                    grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                    totalChargesLbl.text = " $\(grandTotal)"
                }
            } else {
                cell.headServiceBtn.setImage(tickedBox, for: .normal)
            }
            isServicesTypeOneBtnSelected = !isServicesTypeOneBtnSelected
            self.serviceTableView.reloadData()
        }
        
    }
    
    @IBAction func serviceAPressed(_ sender: Any) {
        if let cell1 = self.serviceTableView.cellForRow(at: index1) as? TypeOneServicesDetailsCell {
            if isServiceASelected == true {
               cell1.serviceTypeABtn.setImage(untickedBox, for: .normal)
                totalhairCutCharges = estimatedCharges(serviceA: -20)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            } else {
                cell1.serviceTypeABtn.setImage(tickedBox, for: .normal)
                totalhairCutCharges = estimatedCharges(serviceA: 20)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            }
            isServiceASelected = !isServiceASelected
        }
    }
    
    @IBAction func serviceBSelected(_ sender: Any) {
        if let cell1 = self.serviceTableView.cellForRow(at: index1) as? TypeOneServicesDetailsCell {
            if isServiceBSelected == true {
                cell1.servicesTypeBBtn.setImage(untickedBox, for: .normal)
                totalhairCutCharges = estimatedCharges(serviceB: -25)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            } else {
                cell1.servicesTypeBBtn.setImage(tickedBox, for: .normal)
                totalhairCutCharges = estimatedCharges(serviceB: 25)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            }
            isServiceBSelected = !isServiceBSelected
        }
    }
    @IBAction func serviceCSelected(_ sender: Any) {
        if let cell1 = self.serviceTableView.cellForRow(at: index1) as? TypeOneServicesDetailsCell {
            if isServiceCSelected == true {
                cell1.servicesTypeCBtn.setImage(untickedBox, for: .normal)
                totalhairCutCharges = estimatedCharges(serviceC: -30)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            } else {
                cell1.servicesTypeCBtn.setImage(tickedBox, for: .normal)
                totalhairCutCharges = estimatedCharges(serviceC: 30)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            }
            isServiceCSelected = !isServiceCSelected
        }
    }
    
    @IBAction func massgeServicesSelected(_ sender: Any) {
        if let cell2 = self.serviceTableView.cellForRow(at: index2) as? MassageServicesCell {
            if isMassageServiceSelected {
                cell2.massageServiceHeadBtn.setImage(untickedBox, for: .normal)
                if let cell3 = self.serviceTableView.cellForRow(at: index3) as? MassageServicesDetailsCell {
                    cell3.massageTypeABtn.setImage(untickedBox, for: .normal)
                    cell3.massageTypeBBtn.setImage(untickedBox, for: .normal)
                    cell3.massageTypeCBtn.setImage(untickedBox, for: .normal)
                    isMassageTypeASelected = false
                    isMassageTypeBSelected = false
                    isMassageTypeCSelected = false
                    massageServiceTotal = 0
                    totalMassageCharges = estimatedMassageCharges(massageA: 0, massageB: 0, massageC: 0)
                    grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                    totalChargesLbl.text = " $\(grandTotal)"
                }
            } else {
                cell2.massageServiceHeadBtn.setImage(tickedBox, for: .normal)
            }
            isMassageServiceSelected = !isMassageServiceSelected
            self.serviceTableView.reloadData()
        }
    }
    
    @IBAction func massgeTypeASelected(_ sender: Any) {
        if let cell3 = self.serviceTableView.cellForRow(at: index3) as? MassageServicesDetailsCell {
            if isMassageTypeASelected {
                cell3.massageTypeABtn.setImage(untickedBox, for: .normal)
                totalMassageCharges = estimatedMassageCharges(massageA: -5)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            } else {
                cell3.massageTypeABtn.setImage(tickedBox, for: .normal)
                totalMassageCharges = estimatedMassageCharges(massageA: 5)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            }
            isMassageTypeASelected = !isMassageTypeASelected
        }
    }
    
    @IBAction func massageTypeBSelected(_ sender: Any) {
        if let cell3 = self.serviceTableView.cellForRow(at: index3) as? MassageServicesDetailsCell {
            if isMassageTypeBSelected {
                cell3.massageTypeBBtn.setImage(untickedBox, for: .normal)
                totalMassageCharges = estimatedMassageCharges(massageB: -15)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            } else {
                cell3.massageTypeBBtn.setImage(tickedBox, for: .normal)
                totalMassageCharges = estimatedMassageCharges(massageB: 15)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            }
            isMassageTypeBSelected = !isMassageTypeBSelected
        }
    }
    
    @IBAction func massgeTypeCSelected(_ sender: Any) {
        if let cell3 = self.serviceTableView.cellForRow(at: index3) as? MassageServicesDetailsCell {
            if isMassageTypeCSelected {
                cell3.massageTypeCBtn.setImage(untickedBox, for: .normal)
                totalMassageCharges = estimatedMassageCharges(massageC: -25)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            } else {
                cell3.massageTypeCBtn.setImage(tickedBox, for: .normal)
                totalMassageCharges = estimatedMassageCharges(massageC: 25)
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            }
            isMassageTypeCSelected = !isMassageTypeCSelected
        }
    }
    
    @IBAction func facialServicesSelected(_ sender: Any) {
        if let cell4 = self.serviceTableView.cellForRow(at: index4) as? FacialServicesCell {
            if isFacialServiceSelected {
                cell4.facialServiceHeadBtn.setImage(untickedBox, for: .normal)
                totalFacialCharges = 0
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
                
            } else {
                cell4.facialServiceHeadBtn.setImage(tickedBox, for: .normal)
                if let cell5 = self.serviceTableView.cellForRow(at: index5) as? FacialServicesTypeCell {
                    cell5.facialTypeABtn.isSelected = true
                }
                totalFacialCharges = 32
                grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
                totalChargesLbl.text = " $\(grandTotal)"
            }
            isFacialServiceSelected = !isFacialServiceSelected
            self.serviceTableView.reloadData()
        }
    }
    @IBAction func facialServiceTypeASelected(_ sender: Any) {
        if let cell5 = self.serviceTableView.cellForRow(at: index5) as? FacialServicesTypeCell {
            cell5.facialTypeABtn.isSelected = true
            totalFacialCharges = 32
            grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
            totalChargesLbl.text = " $\(grandTotal)"
        }
    }
    @IBAction func facialServiceTypeBSelected(_ sender: Any) {
        if let cell5 = self.serviceTableView.cellForRow(at: index5) as? FacialServicesTypeCell {
            cell5.facialTypeBBtn.isSelected = true
            totalFacialCharges = 64
            grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
            totalChargesLbl.text = " $\(grandTotal)"
        }
    }
    @IBAction func facialServiceTypeCSelected(_ sender: Any) {
        if let cell5 = self.serviceTableView.cellForRow(at: index5) as? FacialServicesTypeCell {
            cell5.facialTypeCBtn.isSelected = true
            totalFacialCharges = 96
            grandTotal = estimatedTotalCharges(haircutCharges: totalhairCutCharges, massageCharges: totalMassageCharges, facialCharges: totalFacialCharges)
            totalChargesLbl.text = " $\(grandTotal)"
        }
    }
    
    
    func estimatedCharges(serviceA:Int = 0, serviceB:Int = 0, serviceC:Int = 0 ) -> Int {
        let total = haircutTotal + serviceA + serviceB + serviceC
        haircutTotal = ( total < 0 ) ? 0 : total
        print(total)
        return total
    }
    
    func estimatedMassageCharges(massageA: Int = 0, massageB: Int = 0, massageC: Int = 0) -> Int {
        let totalMassge = massageServiceTotal + massageA + massageB + massageC
        massageServiceTotal = ( totalMassge < 0 ) ? 0 : totalMassge
        return totalMassge
    }
    
    func estimatedTotalCharges( haircutCharges: Int = 0, massageCharges: Int = 0, facialCharges: Int = 0) -> Int {
        let totalCharges = haircutCharges + massageCharges + facialCharges
        //tempTotal = ( totalCharges < 0 ) ? 0 : totalCharges
        print(totalCharges)
        return totalCharges
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = self.serviceTableView.dequeueReusableCell(withIdentifier: "servicesTypeOneCell", for: indexPath) as? ServicesTypeOneCell {
                return cell
            }
        }
            if indexPath.row == 1 {
                if let cell1 = self.serviceTableView.dequeueReusableCell(withIdentifier: "typeOneServicesDetailsCell", for: indexPath) as? TypeOneServicesDetailsCell {
                    return cell1
            }
        }
        if indexPath.row == 2 {
            if let cell2 = self.serviceTableView.dequeueReusableCell(withIdentifier: "massageServicesCell", for: indexPath) as? MassageServicesCell {
                return cell2
            }
        }
        if indexPath.row == 3 {
            if let cell3 = self.serviceTableView.dequeueReusableCell(withIdentifier: "massageServicesDetailsCell", for: indexPath) as? MassageServicesDetailsCell {
                return cell3
            }
        }
        if indexPath.row == 4 {
            if let cell4 = self.serviceTableView.dequeueReusableCell(withIdentifier: "facialServicesCell", for: indexPath) as? FacialServicesCell {
                return cell4
            }
        }
        if indexPath.row == 5 {
            if let cell5 = self.serviceTableView.dequeueReusableCell(withIdentifier: "facialServicesDetailsCell", for: indexPath) as? FacialServicesTypeCell {
                return cell5
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            if isServicesTypeOneBtnSelected == true {
                return 90
            } else {
                return 0
            }
        }
        if indexPath.row == 3 {
            if isMassageServiceSelected == true {
                return 90
            } else {
                return 0
            }
        }
        if indexPath.row == 5 {
            if isFacialServiceSelected == true {
                return 90
            } else {
                return 0
            }
        }
        return 40
    }
}
 
/*
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allCharacters:[Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allCharacters = [Character(name: "All"),Character(name: "Luke Skywalker"),Character(name: "Leia Organa"),Character(name: "Advik Shah"),Character(name: "Aarav Modi")]
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCharacters.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = allCharacters[indexPath.row].name
        if allCharacters[indexPath.row].isSelected
        {
            cell?.accessoryType = .checkmark
        }
        else
        {
            cell?.accessoryType = .none
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            allCharacters[indexPath.row].isSelected = !allCharacters[indexPath.row].isSelected
            for index in allCharacters.indices
            {
                allCharacters[index].isSelected = allCharacters[indexPath.row].isSelected
            }
        }
        else
        {
            allCharacters[indexPath.row].isSelected = !allCharacters[indexPath.row].isSelected
            if allCharacters.dropFirst().filter({ $0.isSelected }).count == allCharacters.dropFirst().count
            {
                allCharacters[0].isSelected = true
            }
            else
            {
                allCharacters[0].isSelected = false
            }
        }
        tableView.reloadData()
    }
    
    
    
    
}

struct Character
{
    var name:String
    //  var otherDetails
    var isSelected:Bool! = false
    init(name:String) {
        self.name = name
    }
}
 */
 
