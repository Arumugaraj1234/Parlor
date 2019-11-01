//
//  ProfileVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-28.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var oldPassTxt: RoundedTextField!
    @IBOutlet weak var newPassTxt: RoundedTextField!
    @IBOutlet weak var confirmPassTxt: RoundedTextField!
    @IBOutlet weak var changePassBtn: UIButton!
    @IBOutlet weak var oldPassErrorLbl: UILabel!
    @IBOutlet weak var newPassErrorLbl: UILabel!
    @IBOutlet weak var confirmPassErrorLbl: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        setupView()
        oldPassTxt.tag = 0
        oldPassTxt.delegate = self
        newPassTxt.tag = 1
        newPassTxt.delegate = self
        confirmPassTxt.tag = 2
        confirmPassTxt.delegate = self
        hideKeyboardWhenTappedAround()
        print(userId)
    }

    func setupView() {
        detailsView.layer.cornerRadius = 10.0
        detailsView.layer.borderWidth = 1.0
        detailsView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        changePassBtn.layer.cornerRadius = 5.0
        changePassBtn.layer.borderWidth = 1.0
        changePassBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        oldPassErrorLbl.text = ""
        newPassErrorLbl.text = ""
        confirmPassErrorLbl.text = ""
        oldPassTxt.attributedPlaceholder = NSAttributedString(string: "old password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        newPassTxt.attributedPlaceholder = NSAttributedString(string: "new password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        confirmPassTxt.attributedPlaceholder = NSAttributedString(string: "confirm password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        
        let order = uiRealm.objects(PersonalDB.self).filter("email == '\(AuthService.instance.userEmail)'")
        for item in order {
            let fiName = item.firstName
            let laName = item.lastName
            let phone = item.phoneNo
            let email = item.email
            userId = item.userId
            firstName.text = fiName
            lastName.text = laName
            emailLbl.text = email
            phoneLbl.text = phone
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let titleLabel = UILabel(frame: CGRect(x: (self.view.frame.width/2) - 50, y: 0, width: 100, height: 40))
        titleLabel.text = "PROFILE"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)
        navigationItem.titleView = titleLabel
    }
    
    @IBAction func changePasswordBtnPressed(_ sender: Any) {
        changePassBtn.isEnabled = false
        shouldPresentLoadingViewWithText(true, "Changing...")
        resignFirstResponder()
        if oldPassTxt.text != "" && newPassTxt.text != "" && confirmPassTxt.text != "" {
            if oldPassErrorLbl.text == "" && newPassErrorLbl.text == "" && confirmPassErrorLbl.text == "" {
                AuthService.instance.changePassword(userId: userId, oldPass: oldPassTxt.text!, newPass: newPassTxt.text!, completion: { (success) in
                    if success {
                        self.changePassBtn.isEnabled = true
                        self.shouldPresentLoadingViewWithText(false, "")
                        UserDataService.instance.logoutUser()
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        let alert:UIAlertController = UIAlertController(title: "SUCCESS", message: "Your have changes Password Successfully", preferredStyle: .alert)
                        let done: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                        { _ in
                            let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let shopVC = main.instantiateViewController(withIdentifier: "SWReveal") as! SWRevealViewController
                            self.present(shopVC, animated: true, completion: nil)
                        }
                        alert.addAction(done)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.changePassBtn.isEnabled = true
                        self.shouldPresentLoadingViewWithText(false, "")
                        let alert:UIAlertController = UIAlertController(title: "Failed!", message: "Old Password Did Not Match", preferredStyle: .alert)
                        let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(done)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
                changePassBtn.isEnabled = true
                shouldPresentLoadingViewWithText(false, "")
                let alert:UIAlertController = UIAlertController(title: "Alert!", message: "Please check the Error warnings", preferredStyle: .alert)
                let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            changePassBtn.isEnabled = true
            shouldPresentLoadingViewWithText(false, "")
            oldPassErrorLbl.text = "This field is empty"
            newPassErrorLbl.text = "This field is empty"
            confirmPassErrorLbl.text = "This field is empty"
            let alert:UIAlertController = UIAlertController(title: "Alert!", message: "Please fill all req details", preferredStyle: .alert)
            let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            if textField.text == "" {
                oldPassErrorLbl.text = "This field is empty"
            } else {
                oldPassErrorLbl.text = ""
            }
        }
        if textField.tag == 1 {
            if textField.text == "" {
                newPassErrorLbl.text = "This field is empty"
            } else {
                if (textField.text?.count)! < 7 {
                    newPassErrorLbl.text = "Password must contain min 6 charactors"
                } else {
                    newPassErrorLbl.text = ""
                }
            }
        }
        if textField.tag == 2 {
            if textField.text == "" {
                confirmPassErrorLbl.text = "This field is empty"
            } else {
                if textField.text != newPassTxt.text {
                    confirmPassErrorLbl.text = "Password Not Matched"
                } else {
                    confirmPassErrorLbl.text = ""
                }
            }
        }
    }

}
