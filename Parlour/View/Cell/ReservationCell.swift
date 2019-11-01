//
//  ReservationCell.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-28.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class ReservationCell: UITableViewCell {
    
    //Outlets
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var parlorName: UILabel!
    @IBOutlet weak var stylistNameLbl: UILabel!
    @IBOutlet weak var stylesSelectedLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var reservationDelegate: ReservationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setupView()
    }
    
    func setupView() {
        cancelBtn.layer.cornerRadius = 3.0
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cellView.layer.cornerRadius = 10.0
        cellView.layer.borderWidth = 1.0
        cellView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelReservation(_ sender: UIButton) {
        reservationDelegate?.didPressButton(self.tag)
    }
    
    func configureCell(reservation:ReservationModel) {
        orderIdLbl.text = "\(reservation.appointmentId!)"
        parlorName.text = reservation.parlourName
        stylistNameLbl.text = reservation.stylistName
        stylesSelectedLbl.text = reservation.selectedStyles
        dateLbl.text = reservation.appointmentDate
        costLbl.text = "\(reservation.fare!)"
    }

}
