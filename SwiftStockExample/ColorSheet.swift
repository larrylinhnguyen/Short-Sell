//
//  ColorSheet.swift
//  Quotes
//
//  Created by Larry on 9/30/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import Foundation
import UIKit
class ColorSheet {
    
     let stockGreen : UIColor = UIColor.colorWithRedValue(29, greenValue: 204, blueValue: 146, alpha: 1.0)
     let stockRed : UIColor = UIColor.colorWithRedValue(202, greenValue: 31, blueValue: 39, alpha: 1.0)
   
     let orangeBloomberg : UIColor = UIColor.colorWithRedValue(251, greenValue: 139, blueValue: 30, alpha: 1.0)
    
    let pinkColor : UIColor = UIColor.colorWithRedValue(239, greenValue: 0, blueValue: 57, alpha: 1.0)

    let deepGreyColor: UIColor = UIColor.colorWithRedValue(50, greenValue: 50, blueValue: 50, alpha: 1.0)
    
    let prettyLightGreyColor : UIColor = UIColor.colorWithRedValue(155, greenValue: 155, blueValue: 155, alpha: 1.0)
    
    let lightCreamColor : UIColor = UIColor.colorWithRedValue(231, greenValue: 231, blueValue: 231, alpha: 0.7)
    
    //love table grey scheme
    
    let loveLightGreenGrey : UIColor = UIColor.colorWithRedValue(219, greenValue: 219, blueValue: 206, alpha: 0.8)
    
    let LoveLightGrey : UIColor = UIColor.colorWithRedValue(152, greenValue: 152, blueValue: 152, alpha: 0.8)
    
    let loveDarkGrey : UIColor = UIColor.colorWithRedValue(152, greenValue: 152, blueValue: 152, alpha: 0.8)
    
    let loveFogGrey : UIColor = UIColor.colorWithRedValue(211, greenValue: 217, blueValue: 223, alpha: 0.8)
    
    let loveGreenCoffee : UIColor = UIColor.colorWithRedValue(225, greenValue: 225, blueValue: 214, alpha: 0.8)
    
    let loveNavy : UIColor = UIColor.colorWithRedValue(0, greenValue: 68, blueValue: 127, alpha: 0.8)
}

extension UIColor {
    
    
    static func colorWithRedValue(_ redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
    
}


extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50
        return sizeThatFits
    }
}


