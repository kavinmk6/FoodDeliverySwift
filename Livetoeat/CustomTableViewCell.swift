//
//  CustomTableViewCell.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-01.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var lbl_mealname: UILabel!
    @IBOutlet weak var lbl_caloriecount: UILabel!
    @IBOutlet weak var lbl_pricemeal: UILabel!
    @IBOutlet weak var lbl_secriptionmeal: UILabel!
    @IBOutlet weak var bt_addmeal: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
