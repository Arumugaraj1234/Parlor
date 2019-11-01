//
//  ReservationModel.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-28.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import Foundation

struct ReservationModel {
    public private(set) var appointmentId:Int!
    public private(set) var parlourName: String!
    public private(set) var stylistName: String!
    public private(set) var selectedStyles: String!
    public private(set) var appointmentDate: String!
    public private(set) var fare: Double!
}
