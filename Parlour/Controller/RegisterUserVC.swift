//
//  RegisterUserVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-25.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class RegisterUserVC: UIViewController, UITextFieldDelegate, PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate {
    
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
    @IBOutlet weak var firstNameTxt: RoundedTextField!
    @IBOutlet weak var lastNameTxt: RoundedTextField!
    @IBOutlet weak var emailTxt: RoundedTextField!
    @IBOutlet weak var phoneTxt: RoundedTextField!
    @IBOutlet weak var firstNameErrorLbl: UILabel!
    @IBOutlet weak var lastNameErrorLbl: UILabel!
    @IBOutlet weak var emailErrorLbl: UILabel!
    @IBOutlet weak var phoneErrorLbl: UILabel!
    @IBOutlet weak var bookNowBtn: UIButton!
    
    
    //var delegate: PersonalDetailsDelegate?
    var stylistId: Int?
    var stylestoBook: String?
    var startTime: String?
    var endTime: String?
    var fare: Double?
    var paymentType: Int?
    var paymentStatus = 0
    var txnNo = ""
    var transactionId = ""
    var payStatus = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        firstNameTxt.delegate = self
        lastNameTxt.delegate = self
        emailTxt.delegate = self
        phoneTxt.delegate = self
        firstNameTxt.tag = 0
        lastNameTxt.tag = 1
        emailTxt.tag = 2
        phoneTxt.tag = 3
        hideKeyboardWhenTappedAround()
        
        //PayPalPolicy
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "AeroFleetServices"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    
    func setupView() {
        bookNowBtn.layer.cornerRadius = 5.0
        bookNowBtn.layer.borderWidth = 1.0
        bookNowBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        firstNameErrorLbl.text = ""
        lastNameErrorLbl.text = ""
        emailErrorLbl.text = ""
        phoneErrorLbl.text = ""
        firstNameTxt.attributedPlaceholder = NSAttributedString(string: "first name", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        lastNameTxt.attributedPlaceholder = NSAttributedString(string: "last name", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        phoneTxt.attributedPlaceholder = NSAttributedString(string: "phone", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)])
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func bookNowBtnPressed(_ sender: UIButton) {
        bookNowBtn.isEnabled = false
        if firstNameTxt.text != "" && lastNameTxt.text != "" && emailTxt.text != "" && phoneTxt.text != "" {
            if firstNameErrorLbl.text == "" && lastNameErrorLbl.text == "" && emailErrorLbl.text == "" && phoneErrorLbl.text == "" {
                if paymentType == 1 {
                    payByCash()
                } else {
                    self.payPayPaymentAction()
                }
                
            } else {
                bookNowBtn.isEnabled = true
                let alert:UIAlertController = UIAlertController(title: "Alert!", message: "Please provide all req details", preferredStyle: .alert)
                let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            bookNowBtn.isEnabled = true
            firstNameErrorLbl.text = "This field is empty"
            lastNameErrorLbl.text = "This field is empty"
            emailErrorLbl.text = "This field is empty"
            phoneErrorLbl.text = "This field is empty"
            let alert:UIAlertController = UIAlertController(title: "Alert!", message: "Please provide all req details", preferredStyle: .alert)
            let done:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func payByCash() {
        shouldPresentLoadingViewWithText(true, "Saving appointment")
        if paymentType == 1 {
            paymentStatus = 0
            txnNo = ""
        } else {
            txnNo = transactionId
            paymentStatus = 1
        }
        
        print("parlorId: \(AuthService.instance.selectedParlorId!)")
        print("StylistId: \(stylistId!)")
        print("UserId: 0")
        print("request: \(stylestoBook!)")
        print("startTime: \(startTime!)")
        print("endTime: \(endTime!)")
        print("firstName: \(firstNameTxt.text!)")
        print("lastName: \(lastNameTxt.text!)")
        print("email: \(emailTxt.text!)")
        print("phone: \(phoneTxt.text!)")
        print("fare: \(fare!)")
        print("paymentType: \(paymentType!)")
        print("paymentStatus: \(paymentStatus)")
        print("txnNumber:\(txnNo) ")

        AuthService.instance.newAppointmentCreation(parlourId: AuthService.instance.selectedParlorId!, stylistId: stylistId!, userId: 0, request: stylestoBook!, startTime: startTime!, endTime: endTime!, firstName: firstNameTxt.text!, lastName: lastNameTxt.text!, email: emailTxt.text!, phone: phoneTxt.text!, fare: fare!, paymentType: paymentType!, paymentStatus: paymentStatus, txnNumber: txnNo) { (success) in
            if success {
                self.bookNowBtn.isEnabled = true
                self.shouldPresentLoadingViewWithText(false, "")
                let alert:UIAlertController = UIAlertController(title: "SUCCESS", message: "Your Reservation Confirmed With Order ID : \(AuthService.instance.orderId!). And you have been registered with this email. Password sent to your mail id.", preferredStyle: .alert)
                let done: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                { _ in
                    AuthService.instance.styles.removeAll()
                    AuthService.instance.styleCatIds.removeAll()
                    AuthService.instance.categories.removeAll()
                    AuthService.instance.selectedCategoryCellBtnIndex.removeAll()
                    AuthService.instance.selectedStyles.removeAll()
                    self.performSegue(withIdentifier: UNWIND_FROM_REGISTER, sender: nil)
                }
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.bookNowBtn.isEnabled = true
                self.shouldPresentLoadingViewWithText(false, "")
                self.alertViewToShow(alertTitle: "Oops!", alertMsg: "Something went wrong. Please try again later.", alertStyle: .alert, btnTitle: "OK", btnStyle: .cancel, handler: nil, completion: {
                    self.performSegue(withIdentifier: UNWIND_FROM_REGISTER, sender: nil)
                })
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTxt {
            textField.resignFirstResponder()
            lastNameTxt.becomeFirstResponder()
        } else if textField == lastNameTxt {
            textField.resignFirstResponder()
            emailTxt.becomeFirstResponder()
        } else if textField == emailTxt {
            textField.resignFirstResponder()
            phoneTxt.becomeFirstResponder()
        } else if textField == phoneTxt {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            if textField.text == "" {
                firstNameErrorLbl.text = "This field is empty"
            } else {
                firstNameErrorLbl.text = ""
            }
        }
        if textField.tag == 1 {
            if textField.text == "" {
               lastNameErrorLbl.text = "This field is empty"
            } else {
                lastNameErrorLbl.text = ""
            }
        }
        if textField.tag == 2 {
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
        if textField.tag == 3 {
            if textField.text == "" {
                phoneErrorLbl.text = "This field is empty"
            } else {
                if (textField.text?.count)! < 10 && (textField.text?.count) != 0 {
                    phoneErrorLbl.text = "This phone no is invalid"
                } else {
                    phoneErrorLbl.text = ""
                }
            }
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
        
        let item1 = PayPalItem(name: "PARLOUR", withQuantity: 1, withPrice: NSDecimalNumber(string: String(self.fare!)), withCurrency: "CAD", withSku: "Hip-00000")
        
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
        self.bookNowBtn.isEnabled = true
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
        self.bookNowBtn.isEnabled = true
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
        self.bookNowBtn.isEnabled = true
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
