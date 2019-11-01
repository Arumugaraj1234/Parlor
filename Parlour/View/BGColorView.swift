//
//  BGColorView.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-02.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

@IBDesignable
class BGColorView: UIView {

    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientColor = CAGradientLayer()
        gradientColor.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientColor.startPoint = CGPoint(x: 0, y: 0)
        gradientColor.endPoint = CGPoint(x: 1, y: 1)
        gradientColor.frame = self.bounds
        self.layer.insertSublayer(gradientColor, at: 0)
    }

}
