//
//  ProfileTableViewCell.swift
//  Temperature Converter
//
//  Created by admin on 10/30/17.
//  Copyright © 2017 Web In Dream. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
