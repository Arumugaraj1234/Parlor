//
//  PersonalDB.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-27.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit
import RealmSwift

class PersonalDB: Object {
    
    @objc dynamic var created_id = 1
    @objc dynamic var userId = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var email = ""
    @objc dynamic var phoneNo = ""
    
    override static func primaryKey() -> String {
        return "created_id"
    }
    
    static func create() -> PersonalDB {
        let user = PersonalDB()
        user.created_id = lastId()
        return user
    }
    
    static func lastId() -> Int {
        if let auto_id = uiRealm.objects(PersonalDB.self).last {
            return auto_id.created_id + 1
        } else {
            return 1
        }
    }
    
}
