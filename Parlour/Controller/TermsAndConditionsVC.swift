//
//  TermsAndConditionsVC.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-07-24.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(TermsAndConditionsVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}
