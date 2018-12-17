//
//  MenuTableViewCell.swift
//  Temperature Converter
//
//  Created by admin on 11/6/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    
    @IBOutlet var imgSideHeading: UILabel!
    @IBOutlet var lblEmployeeName: UILabel!
    
    @IBOutlet var imgLine: UIImageView!
    @IBOutlet var imgIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
