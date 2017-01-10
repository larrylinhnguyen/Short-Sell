//
//  StockDataCell.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/16.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.


import UIKit

class StockDataCell: UICollectionViewCell {
   
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var fieldValueLbl: UILabel!
    
    func setData(_ data: [String : String]) {
        fieldNameLbl.text = data.keys.first
        fieldValueLbl.text = data.values.first

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
