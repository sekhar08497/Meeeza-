//
//  AttendanceTableViewCell.swift
//  Temperature Converter
//
//  Created by admin on 10/31/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {


    @IBOutlet var lblBreakOut: UILabel!
  
    @IBOutlet var lblBreakIn: UILabel!

    @IBOutlet var lblCheckIn: UILabel!
    @IBOutlet var lblDate: UILabel!
   
  
    @IBOutlet var lblCheckOut: UILabel!
      
    override func awakeFromNib() {
        super.awakeFromNib()
            }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
