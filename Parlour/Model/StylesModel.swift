//
//  StylesModel.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-21.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import Foundation

struct StylesModel: Equatable {

    
    public private(set) var styleId: Int!
    public private(set) var styleName: String!
    public private(set) var serviceTime: Int!
    public private(set) var serviceAmount: Double!
    public private(set) var categoryId: Int!
    
    static func ==(lhs: StylesModel, rhs: StylesModel) -> Bool {
        return lhs.styleId == rhs.styleId
    }
    
//    init(styleId: Int, styleName: String, serviceTime: Int,serviceAmount: Double,categoryId: Int  ) {
//        self.styleId = styleId
//        self.styleName = styleName
//        self.serviceTime = serviceTime
//        self.serviceAmount = serviceAmount
//        self.categoryId = categoryId
//    }
//
//    static func == (lhs: StylesModel, rhs: StylesModel) -> Bool {
//        return lhs.styleId == rhs.styleId
//    }
//
//
//    func unique(styles: [StylesModel]) -> [StylesModel] {
//
//        var uniqueStyles = [StylesModel]()
//
//        for style in styles {
//            if !uniqueStyles.contains(style) {
//                uniqueStyles.append(style)
//            }
//        }
//
//        return uniqueStyles
//    }
}
