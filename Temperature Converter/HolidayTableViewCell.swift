//
//  HolidayTableViewCell.swift
//  Temperature Converter
//
//  Created by admin on 10/31/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class HolidayTableViewCell: UITableViewCell {

    @IBOutlet var lblDays: UILabel!
    @IBOutlet var lblToDate: UILabel!
    @IBOutlet var lblFromDate: UILabel!
    
    @IBOutlet var lblNotes: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
       
                 }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

            }

}
