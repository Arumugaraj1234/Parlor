//
//  ShopDetailsCell.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-02.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class ShopDetailsCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var shopDetailsView: UIView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var streetName: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        shopDetailsView.layer.cornerRadius = 10.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            shopDetailsView.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 0.6014554795)
            shopName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            streetName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            locationLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            //self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            shopDetailsView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6010809075)
            shopName.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
            streetName.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
            locationLbl.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
            //self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(shopDetails:ShopDetails) {
       shopName.text = shopDetails.name
        streetName.text = shopDetails.address
        locationLbl.text = shopDetails.city + ", " + shopDetails.state
    }


}
