//
//  CustomOrerTableViewCell.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-06.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import UIKit

class CustomOrerTableViewCell: UITableViewCell {

    @IBOutlet weak var mealDate: UILabel!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
