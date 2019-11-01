//
//  MenuCell.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-23.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    //Outlets

    @IBOutlet weak var menuLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func cofigurationCell(menuDetails:MenuModel) {
        menuLbl.text = menuDetails.menuTitle
    }

}
