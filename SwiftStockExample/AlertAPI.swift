//
//  AlertAPI.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/16.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.
//

import UIKit

protocol AlertController { }

extension AlertController where Self: UIViewController {
    
    func showAlert( title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithSettings( title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let url = NSURL(string: UIApplicationOpenSettingsURLString) else { return }
            UIApplication.shared.openURL(url as URL)
        }
        alertController.addAction(settingsAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
