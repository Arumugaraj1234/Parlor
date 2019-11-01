//
//  SubmenuCell.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-07-16.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class SubmenuCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var styteBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    
    
    
    var styleDelegate: StyleButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if selected {
//            styteBtn.setImage(SELECTED_CIRCLE, for: .normal)
//        } else {
//            styteBtn.setImage(DESELECTED_CIRCLE, for: .normal)
//        }
//    }
    
    
    @IBAction func styleBtnSelected(_ sender: UIButton) {
        styleDelegate?.styleBtnPressed(self.tag)
        if styteBtn.currentImage == DESELECTED_CIRCLE {
            styteBtn.setImage(SELECTED_CIRCLE, for: .normal)
        } else {
            styteBtn.setImage(DESELECTED_CIRCLE, for: .normal)
        }
    }
    
    func configureCell(style:StylesModel) {
        styteBtn.setTitle(style.styleName!, for: .normal)
        costLbl.text = "\(style.serviceAmount!)"
        let  totalhours = style.serviceTime / 3600
        let totalMinutes = (style.serviceTime - (3600 * totalhours)) / 60

        let hrs = (String(format: "%02d", totalhours))
        let mins = (String(format: "%02d", totalMinutes))
        
        timeLbl.text = hrs + ":" + mins
    }
    

}
