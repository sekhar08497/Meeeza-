//
//  PayrollTableViewCell.swift
//  Temperature Converter
//
//  Created by admin on 10/31/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class PayrollTableViewCell: UITableViewCell {

    
    @IBOutlet var lblNetSalary: UILabel!
    @IBOutlet var lblDeduction: UILabel!
    
    @IBOutlet var lblEntitlement: UILabel!
    
    @IBOutlet var lblMonth: UILabel!
    @IBOutlet var lblGrossSalary: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
