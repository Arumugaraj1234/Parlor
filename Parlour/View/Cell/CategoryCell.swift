//
//  CategoryCell.swift
//  Parlour
//
//  Created by Peach IT Solutions on 2018-06-21.
//  Copyright © 2018 Peach IT Solutions. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource,StyleButtonDelegate {

    

    //Outlets
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var subMenuTable: UITableView!
    @IBOutlet weak var subMenuTableHeight: NSLayoutConstraint!
    
    
    var styleModelAtIndex = [StylesModel]()
    
    
    var categoryCellDelegate: CategoryCellDelegate?
    var styleSelectDelegate: SelectedStyleDelegate?
    var isRowToHide: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subMenuTable.delegate = self
        subMenuTable.dataSource = self
        subMenuTable.estimatedRowHeight = subMenuTable.rowHeight
        subMenuTable.rowHeight = UITableViewAutomaticDimension
        subMenuTableHeight.constant = 0
       
    }
    
    @IBAction func categoryBtnPressed(_ sender: UIButton) {
        subMenuTable.delegate = self
        subMenuTable.dataSource = self
        categoryCellDelegate?.didPressButton(self.tag)
        if categoryBtn.currentImage == SELECTED_ARROW {
            categoryBtn.setImage(DESELECTED_ARROW, for: .normal)
            //subMenuTable.isHidden = true
            subMenuTableHeight.constant = 0
            isRowToHide = true
//            let i = 0
//            for i in 0...styleModelAtIndex.count - 1 {
//                let index = IndexPath(row: i, section: 0)
//                if let cell = subMenuTable.cellForRow(at: index) as? SubmenuCell {
//                    cell.styteBtn.setImage(DESELECTED_CIRCLE, for: .normal)
//                }
//            }
            subMenuTable.reloadData()
            
        } else {
            categoryBtn.setImage(SELECTED_ARROW, for: .normal)
            subMenuTable.isHidden = false
            subMenuTableHeight.constant = subMenuTable.contentSize.height
            isRowToHide = false
            subMenuTable.reloadData()
        }
    }
    
    func tableviewTohide(shouldhide: Bool, atIndex: Int) {
        if shouldhide {
            subMenuTable.isHidden = true
           let index = IndexPath(row: atIndex, section: 0)
            if let cell = subMenuTable.cellForRow(at: index) as? SubmenuCell {
                cell.styteBtn.setImage(DESELECTED_CIRCLE, for: .normal)
            }
        }
    }
    
    
    func configureCell(category:CategoryModel) {
        categoryBtn.setTitle(category.categoryName, for: .normal)
    }
    
    func styleBtnPressed(_ tag: Int) {
        print("Button pressed with index: \(tag)")
        let selStyle = styleModelAtIndex[tag]
        let selStyleId = styleModelAtIndex[tag].styleId
        styleSelectDelegate?.didSelectStyle(selStyle, selStyleId!)
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styleModelAtIndex.count
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        subMenuTable.reloadData()
        let size = CGSize(width: targetSize.width,height: subMenuTable.frame.origin.y + subMenuTable.contentSize.height)
        return size
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = subMenuTable.dequeueReusableCell(withIdentifier: "subMenuCell", for: indexPath) as? SubmenuCell {
            cell.styleDelegate = self
            cell.tag = indexPath.row
            print("At Index: \(indexPath.row),Styles: \(styleModelAtIndex)")
            let style = styleModelAtIndex[indexPath.row]
            cell.configureCell(style: style)
//            if isRowToHide {
//                cell.styteBtn.setImage(DESELECTED_CIRCLE, for: .normal)
//            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isRowToHide {
            return 0
        } else {
            return 35
        }
    }

}
