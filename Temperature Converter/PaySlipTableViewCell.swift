//
//  PaySlipTableViewCell.swift
//  Temperature Converter
//
//  Created by admin on 10/30/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class PaySlipTableViewCell: UITableViewCell {

    @IBOutlet var lblValues: UILabel!
    @IBOutlet var lblCellDescription: UILabel!
    
    @IBOutlet var lblCellSplitter: UILabel!
    
    @IBOutlet var lblCellHeading: UILabel!

    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblSeparator: UILabel!
    
    //@IBOutlet var lblCellMainHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
