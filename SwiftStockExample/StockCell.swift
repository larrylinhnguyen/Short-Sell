//
//  StockCell.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/16.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.

//

import UIKit

class StockCell: UITableViewCell {

    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!

    @IBOutlet weak var exchangeLbl: UILabel!
    
    @IBOutlet weak var assetType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
