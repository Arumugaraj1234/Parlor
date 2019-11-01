//
//  LoginVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-26.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var emailTxt: RoundedTextField!
    @IBOutlet weak var passTxt: RoundedTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var passErrorLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        emailTxt.tag = 0
        passTxt.tag = 1
        emailTxt.delegate = self
        passTxt.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    func setupView() {
        loginBtn.layer.cornerRadius = 5.0
        loginBtn.layer.borderWidth = 1.0
        loginBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailErrorLbl.text = ""
        passErrorLbl.text = ""
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        passTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func forgetPassBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_FORGETPASS_VC, sender: self)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        resignFirstResponder()
        shouldPresentLoadingViewWithText(true, "Logging In...")
        if emailTxt.text != "" && passTxt.text != "" {
            if emailErrorLbl.text == "" && passErrorLbl.text == "" {
                AuthService.instance.getLoginDetails(email: emailTxt.text!, pass: passTxt.text!, completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.shouldPresentLoadingViewWithText(false, "")
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.shouldPresentLoadingViewWithText(false, "")
                        let alert:UIAlertController = UIAlertController(title: "Error", message: "Given Email / Password is Invalid", preferredStyle: .alert)
                        let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(done)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
                shouldPresentLoadingViewWithText(false, "")
                let alert:UIAlertController = UIAlertController(title: "Alert!", message: "Please provide all req details", preferredStyle: .alert)
                let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            shouldPresentLoadingViewWithText(false, "")
            emailErrorLbl.text = "This field is empty"
            passErrorLbl.text = "This field is empty"
            let alert:UIAlertController = UIAlertController(title: "Alert!", message: "Please provide all req details", preferredStyle: .alert)
            let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            if textField.text == "" {
                emailErrorLbl.text = "This field is empty"
            } else {
                if !isValidEmail(testStr: textField.text!) {
                    emailErrorLbl.text = "This email is not valid"
                } else {
                    emailErrorLbl.text = ""
                }
            }
        }
        if textField.tag == 1 {
            if textField.text == "" {
                passErrorLbl.text = "This field is empty"
            } else {
                passErrorLbl.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTxt {
            textField.resignFirstResponder()
            passTxt.becomeFirstResponder()
        } else if textField == passTxt {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
}
