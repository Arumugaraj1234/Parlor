//
//  TimeAndStyleSelectVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-21.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit
import DLRadioButton


class TimeAndStyleSelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, CategoryCellDelegate, SelectedStyleDelegate {

    

    //PayPalVariables
    var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()
    var resultText = ""
    
    //Outlets
    @IBOutlet weak var byCashBtn: DLRadioButton!
    @IBOutlet weak var byPalPalBtn: DLRadioButton!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountTimeLbl: UILabel!
    @IBOutlet weak var dateTxt: RoundedTextField!
    @IBOutlet weak var timeTxt: RoundedTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var termsConditonsBtn: UIButton!
    
    
    
    //Variables
    var selectedStylistid: Int?
    var isCategorySelected: Bool = false
    var abc: Int?
    var tempAmt = 0.0
    var tempTime = 0
    var date = String()
    var beginTime = ""
    var startTime = ""
    var endTime = ""
    var totalServiceTime = 0
    var firstName = ""
    var lastName = ""
    var email = ""
    var phone = ""
    var userId = 0
    var stylestoBook = ""
    var serviceTotalAmount:Double = 0
    var isCatBtnSelected0 = false
    var isCatBtnSelected1 = false
    var isCatBtnSelected2 = false
    var isCatBtnSelected3 = false
    var isCollectionViewOpened = false
    var isLoggedIn = false
    var paymentType = 1
    
    var paymentStatus = 0
    var txnNo = ""
    var transactionId = ""
    var payStatus = ""
    var isHolidaySelected = false
    var isShouldCategorycellexpand = false
    var selectedIndexofCategorytag = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        AuthService.instance.styles.removeAll()
        AuthService.instance.styleCatIds.removeAll()
        AuthService.instance.categories.removeAll()
        AuthService.instance.holidays.removeAll()
        AuthService.instance.userFinalSelectedStyles.removeAll()
        AuthService.instance.userFinalSelectedStyleIds.removeAll()
        setupView()
        getStyles()
        getHolidaysDetails()
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension

        
        dateTxt.delegate = self
        timeTxt.delegate = self
        dateTxt.tag = 0
        timeTxt.tag = 1
        timeTxt.isUserInteractionEnabled = false
        
        //PayPalPolicy
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "AeroFleetServices"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let titleLabel = UILabel(frame: CGRect(x: (self.view.frame.width/2) - 50, y: 0, width: 100, height: 40))
        titleLabel.text = "BOOK HERE"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)
        navigationItem.titleView = titleLabel
    }
    
    func updateTableViewContentInset() {
        let viewHeight: CGFloat = view.frame.size.height
        let tableViewContentHeight: CGFloat = tableView.contentSize.height
        let marginHeight: CGFloat = (viewHeight - tableViewContentHeight) / 2.0
        
        self.tableView.contentInset = UIEdgeInsets(top: marginHeight, left: 0, bottom:  -marginHeight, right: 0)
    }
    
    func setupView() {
        byCashBtn.isSelected = true
        proceedBtn.layer.cornerRadius = 3.0
        proceedBtn.layer.borderWidth = 1.0
        proceedBtn.layer.borderColor = UIColor.darkGray.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.cornerRadius = 10.0
        dateTxt.attributedPlaceholder = NSAttributedString(string: "date", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        timeTxt.attributedPlaceholder = NSAttributedString(string: "time", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
    }
    
    func getCategories() {
        AuthService.instance.getCategoryDetails { (success) in
            if success {
                self.tableView.reloadData()
            } else {
                let alert:UIAlertController = UIAlertController(title: "Oops!", message: "Unable to Load Categories. Try again later", preferredStyle: .alert)
                let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    func getStyles() {
        if selectedStylistid != nil {
            AuthService.instance.getStyleDetails(stylistId: selectedStylistid!, completion: { (success) in
                if success {
                    self.getCategories()
                } else {
                    let alert:UIAlertController = UIAlertController(title: "Oops!", message: "Unable to Load Styles. Try again later", preferredStyle: .alert)
                    let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func getReservedTime() {
        AuthService.instance.getReservedTimeDetails(stylistId: selectedStylistid!, date: date) { (success) in
            if success {
                self.collectionView.reloadData()
            } else {
                
            }
        }
    }
    
    //    func getPersonalDetails(fistName: String, lastName: String, email: String, phone: String) {
    //        self.firstName = fistName
    //        self.lastName = lastName
    //        self.email = email
    //        self.phone = phone
    //        isLoggedIn = true
    //        self.proceedBtn.sendActions(for: .touchUpInside)
    //    }
    
    
    
    @IBAction func goBackBtnPressed(_ sender: Any) {
        AuthService.instance.styles.removeAll()
        AuthService.instance.styleCatIds.removeAll()
        AuthService.instance.categories.removeAll()
        AuthService.instance.selectedCategoryCellBtnIndex.removeAll()
        AuthService.instance.selectedStyles.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        AuthService.instance.styles.removeAll()
        AuthService.instance.styleCatIds.removeAll()
        AuthService.instance.categories.removeAll()
        AuthService.instance.selectedCategoryCellBtnIndex.removeAll()
        AuthService.instance.selectedStyles.removeAll()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func PayByCashSelected(_ sender: Any) {
        byCashBtn.isSelected = true
        byPalPalBtn.isSelected = false
        paymentType = 1
    }
    
    @IBAction func payByPaypalSelected(_ sender: Any) {
        byCashBtn.isSelected = false
        byPalPalBtn.isSelected = true
        paymentType = 2
    }
    
    @IBAction func proceedBtnPressed(_ sender: Any) {
        proceedBtn.isEnabled = false
        if dateTxt.text != "" && timeTxt.text != "" && AuthService.instance.userFinalSelectedStyleIds.count != 0 {
            if termsConditonsBtn.currentImage == WHITE_SELECTED_CIRCLE {
                if AuthService.instance.isLoggedIn {
                    gettingDateTime()
                    getStylesIdInReqFormat()
                    if paymentType == 1 {
                        payByCash()
                    } else {
                        payPayPaymentAction()
                    }
                    //                gettingDateTime()
                    //                getStylesIdInReqFormat()
                    //                payByCash()
                } else {
                    gettingDateTime()
                    getStylesIdInReqFormat()
                    performSegue(withIdentifier: TO_REGISTER_VC, sender: self)
                }
            } else {
                proceedBtn.isEnabled = true
                let alert:UIAlertController = UIAlertController(title: "", message: "Please accept terms & conditions", preferredStyle: .alert)
                let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }

        } else {
            proceedBtn.isEnabled = true
            let alert:UIAlertController = UIAlertController(title: "Error!", message: "Please Fill/Select Required Field", preferredStyle: .alert)
            let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func termsConditionsBtnTapped(_ sender: Any) {

            let termsVC = TermsAndConditionsVC()
            termsVC.modalPresentationStyle = .custom
            present(termsVC, animated: true, completion: nil)

    }
    
    @IBAction func termBtnSelected(_ sender: Any) {
        if termsConditonsBtn.currentImage == WHITE_DESELECT_CIRCLE {
            termsConditonsBtn.setImage(WHITE_SELECTED_CIRCLE, for: .normal)
        } else {
            termsConditonsBtn.setImage(WHITE_DESELECT_CIRCLE, for: .normal)
        }
    }
    
    func getHolidaysDetails() {
        AuthService.instance.getHolidayDates { (success) in
            if success {
                print("We have some holiday")
            } else {
                print("Dont have holiday")
            }
        }
    }
    
    func getStylesIdInReqFormat() {
        print(AuthService.instance.userFinalSelectedStyleIds)
        for item in AuthService.instance.userFinalSelectedStyleIds {
            stylestoBook = stylestoBook + "," + "\(item)"
        }
        print(stylestoBook)
        stylestoBook.remove(at: stylestoBook.startIndex)
        print(stylestoBook)
    }
    
    func payByCash() {
        shouldPresentLoadingViewWithText(true, "Saving appointment")
        let order = uiRealm.objects(PersonalDB.self).filter("email == '\(AuthService.instance.userEmail)'")
        for item in order {
            userId = item.userId
            firstName = item.firstName
            lastName = item.lastName
            email = item.email
            phone = item.phoneNo
        }
        
        if paymentType == 1 {
            paymentStatus = 0
            txnNo = ""
        } else {
            txnNo = transactionId
            paymentStatus = 1
        }
        
        print("parlorId: \(AuthService.instance.selectedParlorId!)")
        print("StylistId: \(selectedStylistid!)")
        print("UserId: 0")
        print("request: \(stylestoBook)")
        print("startTime: \(startTime)")
        print("endTime: \(endTime)")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("phone: \(phone)")
        print("fare: \(serviceTotalAmount)")
        print("paymentType: \(paymentType)")
        print("paymentStatus: \(paymentStatus)")
        print("txnNumber:\(txnNo)")

        
        AuthService.instance.newAppointmentCreation(parlourId: AuthService.instance.selectedParlorId!, stylistId: selectedStylistid!, userId: userId, request: stylestoBook, startTime: startTime, endTime: endTime, firstName: firstName, lastName: lastName, email: email, phone: phone, fare: serviceTotalAmount, paymentType: paymentType, paymentStatus: paymentStatus, txnNumber: txnNo) { (success) in
            if success {
                self.proceedBtn.isEnabled = true
                self.shouldPresentLoadingViewWithText(false, "")
                let alert:UIAlertController = UIAlertController(title: "SUCCESS", message: "Your Reservation Confirmed With Order ID : \(AuthService.instance.orderId!)", preferredStyle: .alert)
                let done: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                { _ in
                    AuthService.instance.styles.removeAll()
                    AuthService.instance.styleCatIds.removeAll()
                    AuthService.instance.categories.removeAll()
                    AuthService.instance.selectedCategoryCellBtnIndex.removeAll()
                    AuthService.instance.selectedStyles.removeAll()
                    self.performSegue(withIdentifier: "reservat", sender: self)
                    //self.performSegue(withIdentifier: UNWIND, sender: nil)
                }
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.proceedBtn.isEnabled = true
                self.shouldPresentLoadingViewWithText(false, "")
                self.alertViewToShow(alertTitle: "Oops!", alertMsg: "Something went wrong. Please try again later.", alertStyle: .alert, btnTitle: "OK", btnStyle: .cancel, handler: nil, completion: {
                    self.performSegue(withIdentifier: UNWIND, sender: nil)
                })
            }
        }
    }
    
    func gettingDateTime() {
        let reqDateTime = "\(date)\(beginTime)"
        let string = reqDateTime
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        //dateFormatter.locale = Locale(identifier: "en_IN") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "MM/dd/yyyyHH:mm"
        let dateArua = dateFormatter.date(from: string)!
        let end = dateArua.addingTimeInterval(TimeInterval(totalServiceTime))
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale
        startTime = dateFormatter.string(from: dateArua)
        endTime = dateFormatter.string(from: end)
    }
    
    
    func didPressButton(_ tag: Int) {
        if isCollectionViewOpened == false {
            let index = IndexPath(row: tag, section: 0)
            if let cell = tableView.cellForRow(at: index) as? CategoryCell {
                if cell.categoryBtn.currentImage == DESELECTED_ARROW {
                    isShouldCategorycellexpand = false
                    cell.subMenuTable.delegate = cell
                    cell.subMenuTable.dataSource = cell
                    cell.subMenuTable.reloadData()
                    tableView.reloadData()
                } else {
                    isShouldCategorycellexpand = true
                    cell.subMenuTable.delegate = cell
                    cell.subMenuTable.dataSource = cell
                    cell.subMenuTable.reloadData()
                    tableView.reloadData()
                }
            }
            if AuthService.instance.selectedCategoryCellBtnIndex.count != 0 {
                if AuthService.instance.selectedCategoryCellBtnIndex.contains(tag) {
                    let indexOfItem = AuthService.instance.selectedCategoryCellBtnIndex.index(of: tag)
                    AuthService.instance.selectedCategoryCellBtnIndex.remove(at: indexOfItem!)
                } else {
                    AuthService.instance.selectedCategoryCellBtnIndex.append(tag)
                }
            } else {
                AuthService.instance.selectedCategoryCellBtnIndex.append(tag)
            }
//
//            let selectedCategoryId = AuthService.instance.categories[tag].categoryId
//            for item in AuthService.instance.styles {
//                if item.categoryId == selectedCategoryId {
//                    let styleId = item.styleId
//                    if AuthService.instance.userFinalSelectedStyleIds.contains(styleId!) {
//                        let indexOfItem = AuthService.instance.userFinalSelectedStyleIds.index(of: styleId!)
//                        AuthService.instance.userFinalSelectedStyleIds.remove(at: indexOfItem!)
//                        AuthService.instance.userFinalSelectedStyles.remove(at: indexOfItem!)
//                    }
//                }
//            }
//
//            var amountArray = [Double]()
//            var timeArray = [Int]()
//            for item in AuthService.instance.userFinalSelectedStyles {
//                    let amount = item.serviceAmount
//                    let time = item.serviceTime
//                    amountArray.append(amount!)
//                    timeArray.append(time!)
//            }
//            var totalSum: Double = 0
//            if amountArray.count != 0 {
//                totalSum = amountArray.reduce(0, +)
//                serviceTotalAmount = totalSum
//            }
//
//            var totalhrs = "00"
//            var totalMins = "00"
//            var totalTime = 0
//            if timeArray.count != 0 {
//                totalTime = timeArray.reduce(0, +)
//                let  totalhours = Int(totalTime / 3600)
//                totalhrs = "\(totalhours)"
//                let totalMinutes = (totalTime - (3600 * totalhours)) / 60
//                totalMins = "\(totalMinutes)"
//            }
//            self.amountTimeLbl.text = "Subtotal : \(totalSum) ; Time Shedule :\(totalhrs):\(totalMins) Hrs"
            
            tableView.reloadData()
        }
    }
 
    
    func getReservedTimeDetails(date: String) {
        AuthService.instance.getReservedTimeDetails(stylistId: selectedStylistid!, date: date) { (success) in
            if success {
                let i = 0
                if AuthService.instance.reservedTimeArray.count != 0 {
                    for i in i...AuthService.instance.reservedTimeArray.count - 1 {
                        if AuthService.instance.timePeriodList.contains(AuthService.instance.reservedTimeArray[i]) {
                            let indexOfItem = AuthService.instance.timePeriodList.index(of: AuthService.instance.reservedTimeArray[i])
                            AuthService.instance.reservedTimeList.append(indexOfItem!)
                        }
                    }
                }
                self.collectionView.reloadData()
                self.timeTxt.isUserInteractionEnabled = true
            } else {
                print("Failed")
            }
        }
    }
    
    func didSelectStyle(_ selectedStyle: StylesModel, _ styleId: Int) {
        if isCollectionViewOpened == false {
            if AuthService.instance.userFinalSelectedStyleIds.contains(styleId) {
                let indexOfItem = AuthService.instance.userFinalSelectedStyleIds.index(of: styleId)
                AuthService.instance.userFinalSelectedStyleIds.remove(at: indexOfItem!)
                AuthService.instance.userFinalSelectedStyles.remove(at: indexOfItem!)
            } else {
                AuthService.instance.userFinalSelectedStyleIds.append(styleId)
                AuthService.instance.userFinalSelectedStyles.append(selectedStyle)
            }
            print(AuthService.instance.userFinalSelectedStyleIds)
            print(AuthService.instance.userFinalSelectedStyles)
            
            
            var amountArray = [Double]()
            var timeArray = [Int]()
            for item in AuthService.instance.userFinalSelectedStyles {
                let amount = item.serviceAmount
                let time = item.serviceTime
                amountArray.append(amount!)
                timeArray.append(time!)
            }
            var totalSum: Double = 0
            if amountArray.count != 0 {
                totalSum = amountArray.reduce(0, +)
                serviceTotalAmount = totalSum
            }
            
            var totalhrs = "00"
            var totalMins = "00"
            var totalTime = 0
            if timeArray.count != 0 {
                totalTime = timeArray.reduce(0, +)
                totalServiceTime = totalTime
                let  totalhours = Int(totalTime / 3600)
                totalhrs = "\(totalhours)"
                let totalMinutes = (totalTime - (3600 * totalhours)) / 60
                totalMins = "\(totalMinutes)"
            }
            self.amountTimeLbl.text = "Subtotal : \(totalSum) ; Time Shedule :\(totalhrs):\(totalMins) Hrs"
        }
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            timeTxt.text = ""
            isCollectionViewOpened = false
            collectionView.isHidden = true
            AuthService.instance.reservedTimeArray.removeAll()
            AuthService.instance.reservedTimeList.removeAll()
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(TimeAndStyleSelectVC.datePickerChanged(datePicker:)), for: .valueChanged)
            let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(TimeAndStyleSelectVC.dismissPicker))
            textField.inputAccessoryView = toolBar
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            datePicker.minimumDate = Date()
            textField.text = dateFormatter.string(from: datePicker.minimumDate!)
            date = textField.text!
        }
        if textField.tag == 1 && isHolidaySelected == false {
            view.endEditing(true)
            isCollectionViewOpened = true
            collectionView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            if textField.text != "" {
                for date in AuthService.instance.holidays {
                    if date == textField.text {
                        self.alertViewToShow(alertTitle: "Holiday", alertMsg: "The Selected date will be holiday. Please select another day", alertStyle: .alert, btnTitle: "OK", btnStyle: .cancel, handler: nil, completion: nil)
                        self.isHolidaySelected = true
                        return
                    } else {
                        self.isHolidaySelected = false
                        self.getReservedTimeDetails(date: textField.text!)
                    }
                }
            }
        }
        if textField.tag == 1 {
            if textField.text != ""  {
                isCollectionViewOpened = false
                collectionView.isHidden = true
            }
        }
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        date = dateFormatter.string(from: datePicker.date as Date)
        dateTxt.text = date
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthService.instance.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            cell.categoryCellDelegate = self
            cell.styleSelectDelegate = self
            cell.tag = indexPath.row
            
            let category = AuthService.instance.categories[indexPath.row]
            cell.configureCell(category: category)
            var reqStyles = [StylesModel]()
            let categoryId = AuthService.instance.categories[indexPath.row].categoryId
            for style in AuthService.instance.styles {
                if style.categoryId == categoryId {
                    reqStyles.append(style)
                }
            }
            
            cell.styleModelAtIndex = reqStyles.removeDuplicates()
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if AuthService.instance.selectedCategoryCellBtnIndex.contains(indexPath.row) {
            return UITableViewAutomaticDimension
        } else {
            return 50
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AuthService.instance.timePeriodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as? TimeCell {
            if AuthService.instance.reservedTimeList.contains(indexPath.row) {
                let labelName = AuthService.instance.timePeriodList[indexPath.row]
                cell.label.text = labelName
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            } else {
                let labelName = AuthService.instance.timePeriodList[indexPath.row]
                cell.label.text = labelName
                cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                cell.isUserInteractionEnabled = true
            }
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTime = AuthService.instance.timePeriodList[indexPath.row]
        timeTxt.text = selectedTime
        beginTime = selectedTime
        isCollectionViewOpened = false
        collectionView.isHidden = true
        timeTxt.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numofColumns : CGFloat = 4
        if UIScreen.main.bounds.width > 320 {
            numofColumns = 5
        }
        let spaceBetweenCells: CGFloat = 5
        let padding: CGFloat = 10
        
        let cellDimension = ((collectionView.bounds.width - padding) - ((numofColumns - 1) * spaceBetweenCells)) / numofColumns
        let height: CGFloat = cellDimension * 0.5
        return CGSize(width: cellDimension, height: height)
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pushSettings" {
            
        } else {
            let regVC = segue.destination as? RegisterUserVC
            //regVC?.delegate = self
            regVC?.stylistId = selectedStylistid!
            regVC?.stylestoBook = stylestoBook
            regVC?.startTime = startTime
            regVC?.endTime = endTime
            regVC?.fare = serviceTotalAmount
            regVC?.paymentType = paymentType
        }
    }
    
    func payPayPaymentAction(){
        
        //orderToAuthorize
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        
        let item1 = PayPalItem(name: "PARLOUR", withQuantity: 1, withPrice: NSDecimalNumber(string: String(self.serviceTotalAmount)), withCurrency: "CAD", withSku: "Hip-00000")
        
        //let item1 = PayPalItem(name: "AeroFleetServices", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.01"), withCurrency: "CAD", withSku: "Hip-00000")
        
        
        
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "CAD", shortDescription: "PARLOUR", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }
        
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        self.proceedBtn.isEnabled = true
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            //SwiftSpinner.show(delay: 1.0, title: "Processing Trip Details")
            let response = (completedPayment.confirmation as NSDictionary).value(forKey: "response") as! NSDictionary
            print(response)
            let transId = response.value(forKey: "id") as! String
            print(transId)
            let transStatus = response.value(forKey: "state") as! String
            self.transactionId = transId
            self.payStatus = transStatus
            self.payByCash()
        })
    }
    
    // MARK: Future Payments
    
    @IBAction func authorizeFuturePaymentsAction(_ sender: AnyObject) {
        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
        present(futurePaymentViewController!, animated: true, completion: nil)
    }
    
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        print("PayPal Future Payment Authorization Canceled")
        self.proceedBtn.isEnabled = true
        futurePaymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable: Any]) {
        print("PayPal Future Payment Authorization Success!")
        // send authorization to your server to get refresh token.
        futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
            self.resultText = futurePaymentAuthorization.description
            print("ResultText==\(self.resultText)")
            
        })
    }
    
    // MARK: Profile Sharing
    
    @IBAction func authorizeProfileSharingAction(_ sender: AnyObject) {
        let scopes = [kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]
        let profileSharingViewController = PayPalProfileSharingViewController(scopeValues: NSSet(array: scopes) as Set<NSObject>, configuration: payPalConfig, delegate: self)
        present(profileSharingViewController!, animated: true, completion: nil)
    }
    
    // PayPalProfileSharingDelegate
    
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
        print("PayPal Profile Sharing Authorization Canceled")
        self.proceedBtn.isEnabled = true
        profileSharingViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable: Any]) {
        print("PayPal Profile Sharing Authorization Success!")
        
        // send authorization to your server
        
        profileSharingViewController.dismiss(animated: true, completion: { () -> Void in
            self.resultText = profileSharingAuthorization.description
            print("ResultText==\(self.resultText)")
            
        })
        
    }
    
}
//extension Array where Element: Hashable {
//    func removingDuplicates() -> [Element] {
//        var addedDict = [Element: Bool]()
//
//        return filter {
//            addedDict.updateValue(true, forKey: $0) == nil
//        }
//    }
//
//    mutating func removeDuplicates() {
//        self = self.removingDuplicates()
//
//    }
//}



extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
