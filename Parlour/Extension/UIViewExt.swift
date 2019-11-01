//
//  UIViewExt.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-07-14.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }
}
