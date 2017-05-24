//
//  PlanningCell.swift
//  J.O.Infos
//
//  Created by joffrey pijoan on 24/05/2017.
//  Copyright © 2017 joffrey pijoan. All rights reserved.
//

import UIKit

class PlanningCell: UITableViewCell {
    @IBOutlet weak var heureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
