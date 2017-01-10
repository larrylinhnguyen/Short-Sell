//
//  StartVC.swift
//  Quotes
//
//  Created by Larry on 9/28/16.
//  Copyright © 2016 Larry Skyla. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class StartVC: UIViewController {
    
    let color = ColorSheet()
    var context = (UIApplication.shared.delegate  as! AppDelegate).coreDataStack.managedContext
    
    @IBOutlet weak var imageView: UIImageView!

  
    
    @IBOutlet weak var nameImage: UIImageView!
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initial logolabel
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    
        
        delay(3.0) {
          self.displayWalk()
    
    

        }
        
        
    }
    
    // func: check if has displayed walkthrough
    
    func displayWalk () {
        
    
        let userDefaults = UserDefaults.standard
        
        let displayedWalkThrough = userDefaults.bool(forKey: "displayedWalk")
        
        if !displayedWalkThrough  {
            
           
                if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController {
                           
                            
                self.present(pageViewController, animated: true, completion: nil)
                    
            }
        }
        
        
        if displayedWalkThrough  {
            
           
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
//            self.performSegueWithIdentifier("segueToTab", sender: nil)

            
            let tabController = self.storyboard!.instantiateViewController(withIdentifier: "tabbarVC") as! UITabBarController
            
            appDelegate.window?.rootViewController = tabController
            appDelegate.window?.makeKeyAndVisible()
            
            let StockNavViewController = tabController.viewControllers![0] as! UINavigationController
            let StockViewController = StockNavViewController.topViewController as! ViewController
            
            
            let StockWatchNavViewController = tabController.viewControllers![1] as! UINavigationController
            let StockWatchViewController = StockWatchNavViewController.topViewController as! StockWatchViewController
            
            
            let NewsNavViewController = tabController.viewControllers![2] as! UINavigationController
            let NewsViewController = NewsNavViewController.topViewController as! NewsViewController
            
            
            
          
           
            

            

                    }
        
    }
    
    
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //add image and blur
    
    func BGIMAGEandBlur () {
        
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height)
        imageView.image = UIImage(named:"iphoneBG Image")
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    
      
        view.addSubview(blurEffectView)
        view.addSubview(imageView)
        
        view.sendSubview(toBack: blurEffectView)
        
        view.sendSubview(toBack: imageView)
        
        
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }


    
   }
//
//let url = NSBundle.mainBundle().URLForResource("Login", withExtension: "gif")
//let imageData = NSData(contentsOfURL: url!)
//
//let imageGIF = UIImage.gifWithData(imageData!)
//imageView = UIImageView(image: imageGIF)
//
//imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//
//
//view.addSubview(imageView)
//view.sendSubviewToBack(imageView)
//

