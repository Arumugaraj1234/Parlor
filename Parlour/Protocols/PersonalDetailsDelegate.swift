//
//  PersonalDetailsDelegate.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-26.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import Foundation

protocol PersonalDetailsDelegate {
    func getPersonalDetails(fistName: String, lastName: String, email: String, phone: String)
}
