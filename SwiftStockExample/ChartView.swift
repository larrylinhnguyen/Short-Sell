//
//  ChartView.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/16.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.

import UIKit

protocol ChartViewDelegate {

    func didChangeTimeRange(range: ChartTimeRange)
}

class ChartView: UIView {
    
    @IBOutlet weak var btnIndicatorView: UIView!
    var delegate: ChartViewDelegate!
    
    class func create() -> ChartView {
        let chartView = UINib(nibName: "ChartView", bundle:nil).instantiate(withOwner: nil, options: nil)[0] as! ChartView
        chartView.btnIndicatorView.layer.cornerRadius = 15
       
        return chartView
    }
    
    @IBAction func timeRangeBtnTapped(_ sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        print("tap")
        btnIndicatorView.center = btn.center
        

        var range: ChartTimeRange = .oneDay
        
        switch btn.tag {
        case 1:
            range = .oneDay
        case 2:
            range = .fiveDays
        case 3:
            range = .tenDays
        case 4:
            range = .oneMonth
        case 5:
            range = .threeMonths
        case 6:
            range = .oneYear
        case 7:
            range = .fiveYears
        default:
            range = .oneDay
        }
        delegate.didChangeTimeRange(range: range)
        
        for view in subviews {
            
            if view.isMember(of: UIButton.self) {
                let subBtn = view as! UIButton
                if btn.tag == subBtn.tag {
                    subBtn.setTitleColor(ColorSheet().orangeBloomberg , for: UIControlState())
                    subBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
                } else {
                    subBtn.setTitleColor(UIColor.white, for: UIControlState())
                    subBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
                }
                
            }
        
        }
        
        
        
    }
    
    
}
