//
//  AuthService.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-18.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import Foundation
import Alamofire


class AuthService {
    
    static let instance = AuthService()
    
    var shops = [ShopDetails]()
    var selectedShop: ShopDetails?
    
    var stylists = [StylishDetails]()
    var selectedStylist: StylishDetails?
    
    var categories = [CategoryModel]()
    var selectedCategory: CategoryModel?
    
    var styles = [StylesModel]()
    var selectedStyle: StylesModel?
    
    var styleCatIds = [Int]()
    var selectedIndex: Int?
    
    var selectedCategoryCellBtnIndex = [Int]()
    
    var selectedStyles = [StylesModel]()
    var selectedStyleId = [Int]()
    var orderId: Int?
    var selectedParlorId: Int?
    var holidays = [String]()
    
    let menuList = [
     MenuModel(menuTitle: "Profile"),
     MenuModel(menuTitle: "Book Now"),
     MenuModel(menuTitle: "Appointments"),
     MenuModel(menuTitle: "History")
    ]
    
    var userFinalSelectedStyles = [StylesModel]()
    var userFinalSelectedStyleIds = [Int]()
    
    var reservedTimeList = [Int]()
    var reservedTimeArray = [String]()
    
    let fixedTimeList = [
        "00:00","00:15","00:30","00:45","01:00","01:15","01:30","01:45",
        "02:00","02:15","02:30","02:45","03:00","03:15","03:30","03:45",
        "04:00","04:15","04:30","04:45","05:00","05:15","05:30","05:45",
        "06:00","06:15","06:30","06:45","07:00","07:15","07:30","07:45",
        "08:00","08:15","08:30","08:45","09:00","09:15","09:30","09:45",
        "10:00","10:15","10:30","10:45","11:00","11:15","11:30","11:45",
        "12:00","12:15","12:30","12:45","13:00","13:15","13:30","13:45",
        "14:00","14:15","14:30","14:45","15:00","15:15","15:30","15:45",
        "16:00","16:15","16:30","16:45","17:00","17:15","17:30","17:45",
        "18:00","18:15","18:30","18:45","19:00","19:15","19:30","19:45",
        "20:00","20:15","20:30","20:45","21:00","21:15","21:30","21:45",
        "22:00","22:15","22:30","22:45","23:00","23:15","23:30","23:45",
        ]
    
    var timePeriodList = [String]()
    
    var startTime: String!
    var endTime: String!
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL_KEY)
        }
    }
    
    var reservationArray = [ReservationModel]()
    var historyArray = [HistoryModel]()
    
    
    func truncateTimePeriodAtBegin(startTime: String) {
        //truncating in begining
        for _ in 0...95 {
            if timePeriodList[0] == startTime {
                print(timePeriodList)
                return
            } else {
                timePeriodList.remove(at: 0)
                print(timePeriodList)
            }
        }
    }
    
    func truncateTimePeriodAtEnd(endTime: String) {
        //truncate from Ending
        for _ in 0...95 {
            if timePeriodList[timePeriodList.count - 1] == endTime {
                print(timePeriodList)
                return
            } else {
                timePeriodList.remove(at: timePeriodList.count - 1)
                print(timePeriodList)
            }
        }
        
    }
    
    func getTimeSettings(completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "id": 1
        ]
        
        Alamofire.request(URL_TO_GET_TIME_SETTINGS, method: .post, parameters: body, encoding: URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let jsonString = response.result.value else {return}
                let resultjson = self.convertToDictionaryA(text: jsonString)
                let start = resultjson!["StartTime"] as! String
                let index = start.index(start.startIndex, offsetBy: 5)
                let mySubstring = start.prefix(upTo: index)
                self.startTime = String(mySubstring)
                print(self.startTime)
                let end = resultjson!["EndTime"] as! String
                self.endTime = String(end.prefix(5))
                print(self.endTime)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    
    func getShopDetails(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_PARLORS, method: .post, parameters: nil, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionary(text: string)  else { return }
                for item in json {
                    let address = item["Address"] as! String
                    let city = item["City"] as! String
                    let name = item["Name"] as! String
                    //let state = item["State"] as! String
                    var state = ""
                    if let a = item["State"] as? String {
                        state = a
                    }
                    let id = item["Id"] as! Int

                    let shop = ShopDetails(name: name, address: address, city: city, state: state, id: id)
                    self.shops.append(shop)
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getStylistDetails(parlorId: Int, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "ParlourId": parlorId
        ]
        
        Alamofire.request(URL_GET_STYLISTS, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionary(text: string)  else { return }
                for item in json {
                    let name = item["Name"] as? String
                    let rating = item["rating"] as? Double
                    let stylistId = item["Id"] as? Int
                    let profileImage = item["Profile"] as? String
                    let profileLink = URL_FOR_PROFILE_IMAGE + profileImage!
                    let noofServices = item["TotOrd"] as? Int
                    let stylist = StylishDetails(stylistName: name!, stylistId: stylistId!, stylistRating: rating!, profileLink: profileLink, noOfServices: noofServices!)
                    self.stylists.append(stylist)
                }
                print(self.stylists)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getCategoryDetails(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CATEGORIES, method: .post, parameters: nil, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionary(text: string)  else { return }
                
                for item in json {
                    let categoryId = item["Id"] as! Int
                    let categoryName = item["Category1"] as! String
                    let category = CategoryModel(categoryId: categoryId, categoryName: categoryName)
                    if self.styleCatIds.contains(categoryId) {
                        self.categories.append(category)
                    }
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getStyleDetails(stylistId: Int, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "StylistId": stylistId
        ]
        
        Alamofire.request(URL_TO_GET_STYLES, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionary(text: string)  else { return }
                for item in json {                    
                    let styleId = item["Id"] as? Int
                    let styleName = item["Name"] as? String
                    let serviceTime = item["Time"] as? Int
                    let serviceAmount = item["Amount"] as? Double
                    let categoryId = item["CategoryId"] as? Int
                    let style = StylesModel(styleId: styleId, styleName: styleName, serviceTime: serviceTime, serviceAmount: serviceAmount, categoryId: categoryId)
                    self.styleCatIds.append(categoryId!)
                    self.styles.append(style)
                }
                self.styleCatIds = self.styleCatIds.removeDuplicates()
                print(self.styles)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getReservedTimeDetails(stylistId: Int, date: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "StylistId": stylistId,
            "date": date
        ]
        
        Alamofire.request(URL_TO_GET_RESERVED_TIME, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionary(text: string)  else { return }
                for item in json {
                   let hour = item["hourIndex"] as? Int
                    let min = item["minIndex"] as? Int
                    let reqIndex = (hour! * 4) + min!
                    let itematreqIndex = self.fixedTimeList[reqIndex]
                    self.reservedTimeArray.append(itematreqIndex)
                }
                print(self.reservedTimeList)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func newAppointmentCreation(parlourId: Int, stylistId: Int, userId: Int, request: String, startTime: String, endTime: String, firstName: String, lastName: String, email: String, phone: String, fare: Double, paymentType: Int, paymentStatus: Int, txnNumber: String , completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "ParlourId": parlourId,
            "StylistId": stylistId,
            "UserId": userId,
            "Request": request,
            "StartTime": startTime,
            "EndTime": endTime,
            "FirstName": firstName,
            "LastName": lastName,
            "Email": email,
            "Phone": phone,
            "Fare": fare,
            "PaymentType": paymentType,
            "PaymentStatus": paymentStatus,
            "TxnNumber": txnNumber
        ]
        
        Alamofire.request(URL_TO_ORDER_BOOK, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionaryA(text: string)  else { return }
                let orId = json["Id"] as? Int
                self.orderId = orId!
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func getLoginDetails(email: String, pass: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "Email": email,
            "Password": pass
        ]
        
        Alamofire.request(URL_TO_LOGIN, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionaryA(text: string)  else { return }
                if let status = json["status"] as? Int {
                    completion(false)
                } else {
                    let id = json["Id"] as! Int
                    let fName = json["FirstName"] as! String
                    let lName = json["LastName"] as! String
                    let eMail = json["Email"] as! String
                    let phone = json["Phone"] as! String
                    
                    self.userEmail = eMail
                    let addUser = PersonalDB.create()
                    print("Added user id is: ", addUser.created_id)
                    addUser.userId = id
                    addUser.firstName = fName
                    addUser.lastName = lName
                    addUser.email = eMail
                    addUser.phoneNo = phone
                    try! uiRealm.write {
                        uiRealm.add(addUser)
                    }
                    self.isLoggedIn = true
                  
                    completion(true)
                }

            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func changePassword(userId: Int, oldPass: String, newPass: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "UserId": userId,
            "OldPassord": oldPass,
            "NewPassword":newPass
        ]
        
        Alamofire.request(URL_TO_CHANGE_PASSWORD, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionaryA(text: string)  else { return }
                let status = json["status"] as! Int
                if status == 1 {
                    completion(true)
                } else {
                    completion(false)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getResevationDetails(userId: Int, status: Int, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "UserId": userId,
            "Status": status
        ]
        
        Alamofire.request(URL_TO_GET_RESERVATIONS, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionary(text: string)  else { return }
                for item in json {
                    let orderId = item["Id"] as! Int
                    let parlor = item["ParlourName"] as! String
                    let stylist = item["StylistName"] as! String
                    let styles = item["styles"] as! String
                    let dateString = item["date"] as! String
                    let date = self.changeDateFormatWithTime(date: dateString)
                    print(date)
                    let fare = item["fare"] as! Double
                    let reserve = ReservationModel(appointmentId: orderId, parlourName: parlor, stylistName: stylist, selectedStyles: styles, appointmentDate: date, fare: fare)
                    self.reservationArray.append(reserve)
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func cancelAppointment(appointId:Int, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "AppointmentId": appointId
        ]
        
        Alamofire.request(URL_TO_CANCEL_APPOINTMENT, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionaryA(text: string)  else { return }
                let status = json["status"] as! Int
                if status == 1 {
                    completion(true)
                } else {
                    completion(false)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getHistoryDetails(userId: Int, status: Int, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "UserId": userId,
            "Status": status
        ]
        
        Alamofire.request(URL_TO_GET_RESERVATIONS, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionary(text: string)  else { return }
                for item in json {
                    let orderId = item["Id"] as! Int
                    let parlor = item["ParlourName"] as! String
                    let stylist = item["StylistName"] as! String
                    let styles = item["styles"] as! String
                    let dateString = item["date"] as! String
                    let date = self.changeDateFormatWithTime(date: dateString)
                    let fare = item["fare"] as! Double
                    let rate = item["rating"] as! Double
                    let history = HistoryModel(appointmentId: orderId, parlourName: parlor, stylistName: stylist, selectedStyles: styles, appointmentDate: date, fare: fare, rating: rate)
                    self.historyArray.append(history)
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func giveRating(appointId:Int, rating: Int, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "AppointmentId": appointId,
            "rating": rating
        ]
        
        Alamofire.request(URL_TO_GIVE_RATING, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionaryA(text: string)  else { return }
                let status = json["data"] as! String
                if status == "Success" {
                    completion(true)
                } else {
                    completion(false)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func forgetPassword(email: String, completion: @escaping CompletionHandler) {
        let body: [String: Any] = [
            "Email": email
        ]
        
        Alamofire.request(URL_TO_FORGET_PASSWORD, method: .post, parameters: body, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionaryA(text: string)  else { return }
                let status = json["status"] as! Int
                if status == 1 {
                    completion(true)
                } else {
                    completion(false)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getHolidayDates(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_TO_GET_HOLIDAYS, method: .post, parameters: nil, encoding:  URLEncoding.httpBody, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                guard let string = response.result.value else { return }
                guard let json = self.convertToDictionary(text: string)  else { return }
                for item in json {
                    let stringDate = item["Date"] as! String
                    let reqDate = self.changeDateFormat(date: stringDate)
                    self.holidays.append(reqDate)
                }
                print(self.holidays)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }

    func convertToDictionary(text: String) -> [[String : Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToDictionaryA(text: String) -> [String : Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func changeDateFormat(date: String) -> String {
        //2018-07-27T00:00:00
        let string = date
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateArua = dateFormatter.date(from: string)!
        //07-14-2018
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateStringa = dateFormatter.string(from: dateArua)
        print("EXACT_DATE : \(dateStringa)")
        return dateStringa
    }
    
    func changeDateFormatWithTime(date: String) -> String {
        //2018-07-27T00:00:00
        let string = date
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateArua = dateFormatter.date(from: string)!
        //07-14-2018
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale
        let dateStringa = dateFormatter.string(from: dateArua)
        print("EXACT_DATE : \(dateStringa)")
        return dateStringa
    }
}
