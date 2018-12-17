//
//  VacationTableViewCell.swift
//  Temperature Converter
//
//  Created by admin on 10/30/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class VacationTableViewCell: UITableViewCell {

    @IBOutlet var lblFDateValue: UILabel!
    @IBOutlet var lblFDateDescription: UILabel!
    @IBOutlet var lblTDateValue: UILabel!
    @IBOutlet var lblTDateDescription: UILabel!
    @IBOutlet var lblCDaysValue: UILabel!
    @IBOutlet var lblCDaysDescription: UILabel!
    @IBOutlet var lblEVDaysDescription: UILabel!
    @IBOutlet var lblNoteValue: UILabel!
    @IBOutlet var lblNoteDescription: UILabel!
    @IBOutlet var lblRVDaysValue: UILabel!
    @IBOutlet var lblEVDaysValue: UILabel!
    @IBOutlet var lblRVDaysDescription: UILabel!
 
        override func awakeFromNib() {
                super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

          }
    
    

}
