//
//  FacialServicesTypeCell.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-14.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit
import DLRadioButton

class FacialServicesTypeCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var facialTypeABtn: DLRadioButton!
    @IBOutlet weak var facialTypeBBtn: DLRadioButton!
    @IBOutlet weak var facialTypeCBtn: DLRadioButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        facialTypeABtn.isSelected = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
