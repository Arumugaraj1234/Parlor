//
//  RounderView.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-21.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

@IBDesignable
class RounderView: UIView {
    
    @IBInspectable var borderColor:UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = 10.0
    }
}
