//
//  Constant.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-02.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//Seques
let TO_SHOP_SELECT_VC = "toShopSelectVC"
let TO_STYLISH_SELECT_VC = "showStylishSelectVC"
let TO_TIME_STYLE_VC = "toSelectStyleAndTimeVC"
let TO_REGISTER_VC = "toRegisterVC"
let UNWIND = "unwindSegue"
let UNWIND_FROM_REGISTER = "unwindFromRegister"
let TO_LOGIN_VC = "toLoginVC"
let TO_FORGETPASS_VC = "toForgetPassVC"
let TO_RESERVATION_FROM_BOOK = "toReservationVC"
let TO_HOME_AFTER_LOGIN = "aftreLoginSegue"

//URL Constants
//http://192.168.1.5/Parlour/WebService.asmx/
//absws.theoinfotech.com/Webservice.asmx
let BASE_URL = "http://absws.theoinfotech.com/WebService.asmx/"
let URL_GET_PARLORS = "\(BASE_URL)GetParlours"
let URL_GET_STYLISTS = "\(BASE_URL)GetStylist"
let URL_GET_CATEGORIES = "\(BASE_URL)GetCategory"
let URL_TO_GET_STYLES = "\(BASE_URL)GetStyles"
let URL_TO_GET_RESERVED_TIME = "\(BASE_URL)GetBookedTimeIndex"
let URL_TO_ORDER_BOOK = "\(BASE_URL)NewAppointment"
let URL_TO_LOGIN = "\(BASE_URL)Login"
let URL_TO_CHANGE_PASSWORD = "\(BASE_URL)ChangePassword"
let URL_TO_GET_RESERVATIONS = "\(BASE_URL)GetAppointments"
let URL_TO_CANCEL_APPOINTMENT = "\(BASE_URL)CancelAppointments"
let URL_TO_GET_HISTORY = "\(BASE_URL)GetAppointments"
let URL_TO_GIVE_RATING = "\(BASE_URL)ApplyRating"
let URL_TO_FORGET_PASSWORD = "\(BASE_URL)ForgetPassword"
let URL_TO_GET_HOLIDAYS = "\(BASE_URL)GetHolidays"
let URL_TO_GET_TIME_SETTINGS = "\(BASE_URL)GetTimeSettings"

let URL_FOR_PROFILE_IMAGE = "http://abs.theoinfotech.com/images/"

//HEADERS
let HEADER = [
    "Content-Type": "application/x-www-form-urlencoded"
]

//Image
let DESELECTED_CIRCLE = UIImage(named: "circleEmpty")!
let SELECTED_CIRCLE = UIImage(named: "circleSelected")!
let DESELECTED_ARROW = UIImage(named: "rightArrow")!
let SELECTED_ARROW = UIImage(named: "downArrow")!
let WHITE_DESELECT_CIRCLE = UIImage(named: "whiteEmptyCircle")!
let WHITE_SELECTED_CIRCLE = UIImage(named: "whiteFilledCircle")!

//User Defaults
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL_KEY = "userEmail"

// Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")



