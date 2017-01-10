//
//  StockComponent.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/116.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct StockComponent {
    
    let price  : String
    let symbol: String
    let company:String
    let percentChange: String
    let changeImage :UIImage
}

extension StockComponent {
    init?(stock: Stock){
    
    let changeImage = PriceTrendIcon(rawValue: stock.changePercent!).priceImage
    self.changeImage = changeImage
    self.company = stock.companyName!
    self.symbol = stock.symbol!
    self.price = stock.last!
    self.percentChange = stock.changePercent!
    }
    
}
