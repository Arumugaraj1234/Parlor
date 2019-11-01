//
//  StylishDetailsCell.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-20.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class StylishDetailsCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var ratingStarOne: UIImageView!
    @IBOutlet weak var workDoneCountLbl: UILabel!
    @IBOutlet weak var scissorImage: UIImageView!
    @IBOutlet weak var ratingLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            containerView.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 0.6014554795)
            profileNameLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            workDoneCountLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6010809075)
            profileNameLbl.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
            workDoneCountLbl.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        }
        
    }
    
    func setupView() {
        containerView.layer.cornerRadius = 10.0
    }
    
    func configureCell(stylist : StylishDetails) {
         profileImage.downloadedFrom(link: stylist.profileLink)
//        if profileImage.downloadedFrom(link: stylist.profileLink) != nil {
//            profileImage.downloadedFrom(link: stylist.profileLink)
//        } else {
//            profileImage.image = UIImage(named: "profileIcon")
//        }
        profileNameLbl.text = stylist.stylistName
        workDoneCountLbl.text = "\(stylist.noOfServices!)"
        scissorImage.image = UIImage(named: "scissorIcon")
        ratingLbl.text = "\(stylist.stylistRating!)"
    }
    


}
