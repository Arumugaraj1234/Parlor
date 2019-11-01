//
//  ForgetPassVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-29.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class ForgetPassVC: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var emailTF: RoundedTextField!
    @IBOutlet weak var emailErrorlbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        emailTF.tag = 0
        hideKeyboardWhenTappedAround()
        setupView()
    }
    
    func setupView() {
        submitBtn.layer.cornerRadius = 5.0
        submitBtn.layer.borderWidth = 1.0
        submitBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailErrorlbl.text = ""
        emailTF.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitActionPressed(_ sender: Any) {
        shouldPresentLoadingViewWithText(true, "Loading...")
//        spinner.isHidden = false
//        spinner.startAnimating()
        if emailTF.text != "" {
            if emailErrorlbl.text == "" {
                AuthService.instance.forgetPassword(email: emailTF.text!, completion: { (success) in
                    if success {
                        self.alertViewToShow(alertTitle: "Success", alertMsg: "Password sent to your mail", alertStyle: .alert, btnTitle: "OK", btnStyle: .cancel, handler: {_ in
                            self.dismiss(animated: true, completion: nil)
                            self.shouldPresentLoadingViewWithText(false, "")
//                            self.spinner.stopAnimating()
//                            self.spinner.isHidden = true
                        }, completion: nil)
                    } else {
                        self.shouldPresentLoadingViewWithText(false, "")
//                        self.spinner.stopAnimating()
//                        self.spinner.isHidden = true
                        self.alertViewToShow(alertTitle: "Oops!", alertMsg: "User Doesn't exist for given mail id", alertStyle: .alert, btnTitle: "OK", btnStyle: .cancel, handler: nil, completion: nil)
                    }
                })
            } else {
                shouldPresentLoadingViewWithText(false, "")
//                spinner.stopAnimating()
//                spinner.isHidden = true
                alertViewToShow(alertTitle: "Alert!", alertMsg: "Please provide valid mail id", alertStyle: .alert, btnTitle: "OK", btnStyle: .cancel, handler: nil, completion: nil)
            }
        } else {
            shouldPresentLoadingViewWithText(false, "")
//            spinner.stopAnimating()
//            spinner.isHidden = true
            emailErrorlbl.text = "This field is empty"
            alertViewToShow(alertTitle: "Alert!", alertMsg: "Please provide valid mail id", alertStyle: .alert, btnTitle: "OK", btnStyle: .cancel, handler: nil, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            if textField.text == "" {
                emailErrorlbl.text = "This field is empty"
            } else {
                if !isValidEmail(testStr: textField.text!) {
                    emailErrorlbl.text = "This email is not valid"
                } else {
                    emailErrorlbl.text = ""
                }
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
