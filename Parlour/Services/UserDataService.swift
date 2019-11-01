//
//  UserDataService.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-27.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    
    func logoutUser() {
        AuthService.instance.userEmail = ""
        AuthService.instance.isLoggedIn = false
    }
    
    
}
