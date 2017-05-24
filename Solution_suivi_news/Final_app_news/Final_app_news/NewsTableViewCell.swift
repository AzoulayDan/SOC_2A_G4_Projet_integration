//
//  NewsTableViewCell.swift
//  Final_app_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var mHourNews: UILabel!
    @IBOutlet weak var mDescriptionNews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func fill_cell (content:String) -> Void {
        self.mDescriptionNews.text = content
        self.mDescriptionNews.numberOfLines = 0
        self.mDescriptionNews.baselineAdjustment = .alignCenters
        self.mDescriptionNews.sizeToFit()
        self.mDescriptionNews.adjustsFontSizeToFitWidth = true
    }    
}
