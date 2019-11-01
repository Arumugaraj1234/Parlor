//
//  HistoryCell.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-28.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    //outlets
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var parlorNameLbl: UILabel!
    @IBOutlet weak var stylistNameLbl: UILabel!
    @IBOutlet weak var selectedStylesLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var starOneBtn: UIButton!
    @IBOutlet weak var starTwoBtn: UIButton!
    @IBOutlet weak var starThreeBtn: UIButton!
    @IBOutlet weak var starFourBtn: UIButton!
    @IBOutlet weak var starFiveBtn: UIButton!
    
    let starEmpty: UIImage = UIImage(named: "emptyStar")!
    let starFull: UIImage = UIImage(named: "fullStar")!
    var ratingDelegate:RatingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        starOneBtn.tag = 1
        starTwoBtn.tag = 2
        starThreeBtn.tag = 3
        starFourBtn.tag = 4
        starFiveBtn.tag = 5
    }
    
    func setupView() {
        cellView.layer.cornerRadius = 10.0
        cellView.layer.borderWidth = 1.0
        cellView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    @IBAction func ratingBtnPressed(_ sender: UIButton) {
        ratingDelegate?.styleBtnPressed(sender.tag, self.tag)
    }
    
    func configureCell(history:HistoryModel) {
        orderIdLbl.text = "\(history.appointmentId!)"
        parlorNameLbl.text = history.parlourName
        stylistNameLbl.text = history.stylistName
        selectedStylesLbl.text = history.selectedStyles
        dateLbl.text = history.appointmentDate
        costLbl.text = "\(history.fare!)"
        if history.rating == 0.0 {
            starOneBtn.setImage(starEmpty, for: .normal)
            starTwoBtn.setImage(starEmpty, for: .normal)
            starThreeBtn.setImage(starEmpty, for: .normal)
            starFourBtn.setImage(starEmpty, for: .normal)
            starFiveBtn.setImage(starEmpty, for: .normal)
        } else if history.rating == 1.0 {
            starOneBtn.setImage(starFull, for: .normal)
            starTwoBtn.setImage(starEmpty, for: .normal)
            starThreeBtn.setImage(starEmpty, for: .normal)
            starFourBtn.setImage(starEmpty, for: .normal)
            starFiveBtn.setImage(starEmpty, for: .normal)
        } else if history.rating == 2.0 {
            starOneBtn.setImage(starFull, for: .normal)
            starTwoBtn.setImage(starFull, for: .normal)
            starThreeBtn.setImage(starEmpty, for: .normal)
            starFourBtn.setImage(starEmpty, for: .normal)
            starFiveBtn.setImage(starEmpty, for: .normal)
        } else if history.rating == 3.0 {
            starOneBtn.setImage(starFull, for: .normal)
            starTwoBtn.setImage(starFull, for: .normal)
            starThreeBtn.setImage(starFull, for: .normal)
            starFourBtn.setImage(starEmpty, for: .normal)
            starFiveBtn.setImage(starEmpty, for: .normal)
        } else if history.rating == 4.0 {
            starOneBtn.setImage(starFull, for: .normal)
            starTwoBtn.setImage(starFull, for: .normal)
            starThreeBtn.setImage(starFull, for: .normal)
            starFourBtn.setImage(starFull, for: .normal)
            starFiveBtn.setImage(starEmpty, for: .normal)
        } else {
            starOneBtn.setImage(starFull, for: .normal)
            starTwoBtn.setImage(starFull, for: .normal)
            starThreeBtn.setImage(starFull, for: .normal)
            starFourBtn.setImage(starFull, for: .normal)
            starFiveBtn.setImage(starFull, for: .normal)
        }
    }


}
