//
//  ChoiceTableViewCell.swift
//  Final_app_news
//
//  Created by Dan Azoulay on 24/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

class ChoiceTableViewCell: UITableViewCell {
    @IBOutlet weak var mSportLabel: UILabel!
    @IBOutlet weak var mIconSport: UIImageView!
    @IBOutlet weak var mSelectedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
