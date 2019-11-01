//
//  SelectedStylesDelegate.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-07-16.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import Foundation

protocol SelectedStyleDelegate {
    func didSelectStyle(_ selectedStyle: StylesModel, _ styleId: Int)
}
