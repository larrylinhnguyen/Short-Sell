//
//  PageContentVCViewController.swift
//  Quotes
//
//  Created by Larry on 9/28/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import UIKit

class PageContentVCViewController: UIViewController {
   
    let color = ColorSheet()
    
    
    @IBOutlet weak var BGImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    var pageIndex = 0
    var contentLbl = ""
    var headerLbl = ""
    var imageName = ""
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        pageControl.currentPage = pageIndex
        
        contentLabel.text = contentLbl
        contentLabel.textColor = color.prettyLightGreyColor
        
        headerLabel.text = headerLbl
        headerLabel.textColor = color.orangeBloomberg   

        image.image = UIImage(named:imageName)
 
       
        
        //custom button
        
        startButton.layer.borderWidth = 4
        startButton.layer.cornerRadius = 4
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.setTitleColor(UIColor.white, for: UIControlState())
        startButton.layer.masksToBounds = true
        
        // BG
        
        BGImage.image = UIImage(named: "StockWatch")
        BGImage.addBlurEffect()
        pageControl.backgroundColor = UIColor.clear
        pageControl.pageIndicatorTintColor? = ColorSheet().orangeBloomberg
        
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startPressed(_ sender: AnyObject) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "displayedWalk")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
  

  
}

