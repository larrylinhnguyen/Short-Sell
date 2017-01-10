//
//  PriceTrendIcon.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/116.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.
//

import Foundation
import UIKit
var sign : String = "up"
enum PriceTrendIcon: String {
    case Up = "up"
    case Down = "down"
    
    init(rawValue: String){
        
        if rawValue.contains("+"){
            sign = "up"
        }else {
            sign = "down"
        }
        switch sign {
            
        case "up" : self = .Up
        case "down" : self = .Down
        default : self = .Up
        }
    }
    
    
}

extension PriceTrendIcon {
    var priceImage : UIImage{
        return UIImage(named: sign)!
    }
}
