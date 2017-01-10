//
//  StockWatchViewController.swift
//  SwiftStockExample
//
//  Created by Larry Nguyen on 12/3/16.
//  Copyright (c) 2016 Larry Nguyen. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class StockWatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AlertController,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {

    var stockSymbol: String = String()
    var stock: Stock!
    var CDStocks : [NSManagedObject] = []
    var stockArray :[Stock] = []
    var symbolArray : [String] = []
    var stockComps : [StockComponent] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    var context: NSManagedObjectContext!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCDStock()
        fetchSymbolYahooFinanceWithString(symbolArray, completion: {
            stockArray in
            
            for stock in stockArray{
                self.stockArray.append(stock)
                
            }
            
            for sc in stockArray{
            let stockcomp = StockComponent(stock: sc)
            self.stockComps.append(stockcomp!)
                print(self.stockComps)
            self.tableView.reloadData()
            }
    
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        setUpInterface()
        navigationItem.title = "STOCK WATCH"
        context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedContext
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //// Interface
    func setUpInterface(){
        
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.layer.backgroundColor = UIColor.clear.cgColor
        self.tableView.separatorColor = ColorSheet().orangeBloomberg
        let BGImageGIF = UIImage(named: "StockWatch")
        
        let BGImageView = UIImageView(image: BGImageGIF)
        BGImageView.addBlurEffect()
        BGImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(BGImageView)
        self.view.sendSubview(toBack: BGImageView)
    }
    
    
    // Basic tableview funcs
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockComps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockWatchCell", for: indexPath) as! StockWatchCell
        cell.symbol.textColor = UIColor.white
        cell.companyName.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        if stockComps[indexPath.row].percentChange.contains("+") {
            cell.percentChange.textColor = ColorSheet().stockGreen

        } else{
            cell.percentChange.textColor = ColorSheet().stockRed
        }
        cell.companyName.text = stockComps[indexPath.row].company
        cell.symbol.text = stockComps[indexPath.row].symbol
        cell.percentChange.text = stockComps[indexPath.row].percentChange
        cell.changeImageView.image  = stockComps[indexPath.row].changeImage
        
        return cell
    }
    
    
    ////// empty data
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Your favorate stocks"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Search and add stock in stock tab first ."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyBoard")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Swipe left tp remove from the list"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        let ac = UIAlertController(title: "Please go to stock tab", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default))
        present(ac, animated: true)
    }

    
    
    // other tableview funcs
    // edit row
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let unwatchAction = UITableViewRowAction(style: .default, title: "Unwatch", handler: { action in
            
            self.context.delete(self.CDStocks[indexPath.row])
            self.stockComps.remove(at: indexPath.row)
            self.tableView.reloadData()
            
        })
        
        
        return [unwatchAction]
    }
    
    
    // Handy funcs
    
    // retrieve cordata data
    func retrieveCDStock (){
        self.symbolArray.removeAll(keepingCapacity: false)
        self.stockArray.removeAll(keepingCapacity:false)
        self.stockComps.removeAll(keepingCapacity: false)
        self.tableView.reloadData()
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<CDStock> = CDStock.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for result in searchResults as [NSManagedObject] {
                self.CDStocks.append(result)
                self.symbolArray.append(result.value(forKey: "symbol") as! String)
                
            }
        } catch {
            showAlert(title: "Error", message: "Can't fetch data")
        }
        
    }
    
    // fetch stock array 
    
    func fetchSymbolYahooFinanceWithString(_ symbolArray: [String], completion: @escaping ([Stock])->()) {
        DispatchQueue.global().async {
            for sym in symbolArray{
                
                SwiftStockKit.fetchStockForSymbol(symbol: sym, completion: {
                    stock -> () in
                    self.stock = stock
                    self.stockArray.append(self.stock)
                   
                    
                    
                })
                
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                print("--------")
                print(self.stockArray.count)
                
                completion(self.stockArray)
                self.tableView.reloadData()
             
            })
        }
        
        
        
        
        
    }
    
    



   }
